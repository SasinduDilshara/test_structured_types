import ballerinax/np;
import ballerina/io;
import ballerina/time;

const TOTAL_ITERATIONS = 100;

public isolated function getAnswer(
    np:Prompt prompt = `Provide detailed information for the user 'Elon Musk'`)
      returns User|error = @np:NaturalFunction external;

int numberOfErrors = 0;
decimal totalDiff = 0;

record {
    decimal average;
    boolean isError;
}[] results = [];

public function main() returns error? {
    int index = 0;

    check io:fileWriteCsv("./epoch_results.csv", <map<anydata>[]>[], option = io:OVERWRITE);

    while index < TOTAL_ITERATIONS {
        decimal st = time:monotonicNow();
        User|error result = getAnswer();
        decimal diff = time:monotonicNow() - st;

        if result is error {
            if result.message().includes("Error occurred while attempting to parse the response") {
                numberOfErrors += 1;
                index = index + 1;
            }
            
            io:println("Error occured:- ", result.message(), ":- ", numberOfErrors);
            continue;
        }

        io:println(index, ":- ", diff);
        totalDiff = totalDiff + diff;
        index = index + 1;

        check io:fileWriteCsv("./epoch_results.csv", [{
            index,
            diff
        }], option = io:APPEND);
    }

    io:println("avg for the batch", totalDiff/TOTAL_ITERATIONS);
    check io:fileWriteCsv("./final_results.csv", [{
        average: totalDiff/(TOTAL_ITERATIONS - numberOfErrors),
        numberOfErrors
    }], option = io:OVERWRITE);
}

type Address record {| 
    string street;
    string city;
    string zipCode;
|};

type ContactInfo record {| 
    string phoneNumber;
    string email;
    string socialMedia;
|};

type Education record {| 
    string degree;
    string institution;
    int yearOfGraduation;
    string major;
|};

type Skill record {| 
    string name;
    string proficiencyLevel; 
|};

type Certification record {| 
    string title;
    string issuedBy;
    int yearIssued;
|};

type Hobby record {| 
    string name;
    string description;
|};

type Project record {| 
    string name;
    string description;
    string technologyUsed;
    int yearStarted;
    Team team; 
|};

type Team record {| 
    string name;
    string role;
    string[] members;
|};

type Company record {| 
    string name;
    string industry;
    Address headquarters;
    string website;
|};

type Job record {| 
    string title;
    Company company;
    string department;
    Project[] projects;  
|};

type User record {| 
    string name;
    Address address;
    Job job;
    ContactInfo contactInfo;
    Education[] educationHistory;
    Skill[] skills;
    Certification[] certifications;
    Hobby[] hobbies;
|};

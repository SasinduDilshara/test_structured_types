import ballerinax/np;
import ballerina/io;
import ballerina/time;

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

public isolated function getAnswer(
    np:Prompt prompt = `Provide detailed information for the user 'Elon Musk'`)
      returns User|error = @np:NaturalFunction external;

public function main() returns error? {
    int index = 0;
    decimal totalDiff = 0;

    while index < 1000 {
        decimal st = time:monotonicNow();
        User _ = check getAnswer();
        decimal diff = time:monotonicNow() - st;
        io:println(index, ":- ", diff);
        totalDiff = totalDiff + diff;
        index = index + 1;
    }

    io:println("avg", totalDiff/1000);
    User answer = check getAnswer();
    io:println(answer);
}

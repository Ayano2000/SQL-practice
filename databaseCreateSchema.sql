-- Table definitions

-- Create table to hold Applicant information
CREATE table if not exists Applicants (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    name varchar(64) not null,
    surname varchar(64) not null,
    email varchar(64) not null,
    idNumber varchar(64) not null,
    cellphone varchar(64) not null,
    birthday VARCHAR(64) not null,
    ethnicity VARCHAR(64) not null,
    gender VARCHAR(64) not null,
    campus VARCHAR(64) not null,
    citizen VARCHAR(64) not null,
    citizenship VARCHAR(64) not null,
    created_on TIMESTAMP not null DEFAULT current_timestamp,
    testID varchar(64) unique,
    student_email VARCHAR(64) unique,
    student_uid VARCHAR(64) unique,
    PRIMARY KEY (ID)
);

-- Create table to hold Questions for the Critical Thinking Test
CREATE table if not exists Questions (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    questionID int not null unique,
    question varchar(1024) not null,
    category varchar(64) not null,
    optionA varchar(64) not null,
    optionB varchar(64) not null,
    optionC varchar(64) not null,
    optionD varchar(64) not null,
    answer char(1) not null,
    PRIMARY KEY (ID)
);

-- Create table to hold the questions assigned to an Applicants test
CREATE table if not exists Tests (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    testID varchar references Applicants(testID),
    questionID int references Questions(questionID),
    PRIMARY KEY (ID)
);

-- todo - Create table to hold the answers the applicant submits

-- Functions and their triggers

-- function to create the uid for an applicant
CREATE function create_uid() returns trigger AS $create_uid$
DECLARE
    campus varchar(64);
    year varchar(64);
    queueNumber varchar(64);
    uid varchar(64);
BEGIN
    SELECT NEW.campus INTO campus;
    SELECT NEW.created_on INTO year;
    SELECT NEW.ID INTO queueNumber;

    SELECT
        SUBSTRING (year FROM 3 FOR 2) INTO year;

    SELECT
        LPAD(queueNumber::text, 4, 0::text) INTO queueNUmber;

    SELECT CONCAT(year, campus, queueNumber) INTO uid;

    RAISE NOTICE 'uid is: %', uid;

    UPDATE Applicants set student_uid = uid where ID = NEW.ID;
    return NEW;
END;
$create_uid$ LANGUAGE plpgsql;

-- trigger to call crate_uid function
CREATE TRIGGER set_uid
    AFTER INSERT ON Applicants
    FOR EACH ROW EXECUTE FUNCTION create_uid();


-- function to create a testID for an applicant
CREATE function create_testID() returns trigger AS $create_testID$
DECLARE
    test_id varchar(64);
BEGIN
    SELECT
        random_value FROM GENERATE_SERIES (1000, 9999)
        AS s(random_value) order by random()
        LIMIT 1 INTO test_id;

    RAISE NOTICE 'test_id is: %', test_id;

    UPDATE Applicants set testID = test_id where Applicants.ID = NEW.ID;
    return NEW;
END;
$create_testID$ LANGUAGE plpgsql;

-- trigger to call the create testId function
CREATE TRIGGER set_testID
    AFTER INSERT ON Applicants
    FOR EACH ROW EXECUTE FUNCTION create_testID();

-- Insert queries to populate the database a bit

INSERT INTO Applicants (name,
                        surname,
                        email,
                        idNumber,
                        cellphone,
                        birthday,
                        ethnicity,
                        gender,
                        campus,
                        citizen,
                        citizenship)
                VALUES ('Arata',
                        'Yano',
                        'aratayano00@gmail.com',
                        '0003235166083',
                        '0762470205',
                        '2000-03-23',
                        'COLOURED',
                        'MALE',
                        '02',
                        'y',
                        'South Africa');

INSERT INTO Applicants (name,
                        surname,
                        email,
                        idNumber,
                        cellphone,
                        birthday,
                        ethnicity,
                        gender,
                        campus,
                        citizen,
                        citizenship)
VALUES ('Glen',
        'Wasserfall',
        'glen@wasserfall.com',
        '9511125166834',
        '0845168524',
        '1995-11-12',
        'WHITE',
        'MALE',
        '02',
        'y',
        'South Africa');

INSERT INTO Applicants (name,
                        surname,
                        email,
                        idNumber,
                        cellphone,
                        birthday,
                        ethnicity,
                        gender,
                        campus,
                        citizen,
                        citizenship)
VALUES ('Carah',
        'Prinsloo',
        'carahprinsloo@gmail.com',
        '9905045166064',
        '0842670205',
        '1999-05-04',
        'WHITE',
        'FEMALE',
        '02',
        'y',
        'South Africa');

INSERT INTO Applicants (name,
                        surname,
                        email,
                        idNumber,
                        cellphone,
                        birthday,
                        ethnicity,
                        gender,
                        campus,
                        citizen,
                        citizenship)
VALUES ('Rachel',
        'Bolton',
        'rachelericabolton@gmail.com',
        '9602055164865',
        '0635198754',
        '1996-02-05',
        'WHITE',
        'FEMALE',
        '02',
        'y',
        'South Africa');

INSERT INTO Questions (questionID,
                       category,
                       question,
                       optionA,
                       optionB,
                       optionC,
                       optionD,
                       answer)
                VALUES ('1',
                        'deductive reasoning',
                        'What is 9 + 10?',
                        '109',
                        '19',
                        '21',
                        '910',
                        'B');

INSERT INTO Questions (questionID,
                       category,
                       question,
                       optionA,
                       optionB,
                       optionC,
                       optionD,
                       answer)
VALUES ('2',
        'inductive reasoning',
        'Where does the sun set?',
        'In the North',
        'In the South',
        'In the West',
        'In the East',
        'C');

INSERT INTO Questions (questionID,
                       category,
                       question,
                       optionA,
                       optionB,
                       optionC,
                       optionD,
                       answer)
VALUES ('3',
        'arithmetic ability',
        'What is the next number in the sequence: 2, 4, 7, 11, ..?',
        '12',
        '9',
        '19',
        '16',
        'D');

INSERT INTO Questions (questionID,
                       category,
                       question,
                       optionA,
                       optionB,
                       optionC,
                       optionD,
                       answer)
VALUES ('4',
        'programming aptitude',
        'If ADD = 9, BAD = 7 and CAD = 8 what is the value of ADA?',
        '7',
        '6',
        '5',
        '11',
        'C');
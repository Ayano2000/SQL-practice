-- Creating table for Applicants information
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

-- Creating table to hold all of the Critical Thinking Test Questions
CREATE table if not exists QuestionStore (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    active smallint not null,
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

-- Create table to hold the 'test' ie. The questions that a test has been assigned
CREATE table if not exists Tests (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    testID varchar references Applicants(testID),
    questionID int references QuestionStore(questionID),
    PRIMARY KEY (ID)
);

-- Create table to hold the Applicants answers to the given test
CREATE table if not exists  Answers (
  ID INTEGER GENERATED ALWAYS AS IDENTITY,
  testID varchar references Applicants(testID),
  questionID int references QuestionStore(questionID),
  answer char(1)
);

-- Function to create the Applicants UID
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

-- Trigger to call function to create applicant UID
CREATE TRIGGER set_uid
    AFTER INSERT ON Applicants
    FOR EACH ROW EXECUTE FUNCTION create_uid();


-- Function to create a test id for the applicant
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

-- Trigger to call the function that creates the test id
CREATE TRIGGER set_testID
    AFTER INSERT ON Applicants
    FOR EACH ROW EXECUTE FUNCTION create_testID();

-- Rule to prevent deletion of any row on the QuestionStore table
CREATE RULE "disable_deletes" AS
    ON DELETE TO QuestionStore
    DO INSTEAD NOTHING;

-- Creating user for us to use when interacting with the db
CREATE USER service_worker WITH PASSWORD 'password';

-- setting privileges for the user
GRANT INSERT, SELECT, UPDATE ON Applicants to service_worker;
GRANT INSERT, SELECT ON QuestionStore to service_worker;
GRANT INSERT, SELECT ON Tests to service_worker;
GRANT INSERT, SELECT ON Answers to service_worker;
GRANT UPDATE (active) ON QuestionStore to service_worker;

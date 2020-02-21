-- Create a table that will host the first name, last name and date of birth of an actor.
-- The table requires an identity column that can be used as a primary key as well as a column that can be used to reference the movie the actor worked on.
-- Call this table “Actors”.
-- Cange the Actors table to add a field that can be used to store the actors image in. This image must be saved in binary format.
-- Change the Actors table to add two additional fields that will contain the place of birth for an actor as well as the country of birth.

CREATE TABLE Actors (
    ActorID int IDENTITY(1,1) NOT NULL,
    FirstName varchar(35) NOT NULL,
	LastName varchar(35) NULL,
    BirthDate date NOT NULL,
	ActorImage varbinary (max) NULL,
	BirthPlace varchar (120) NULL,
	BirthCountry varchar (60) NOT NULL,
);
CREATE TABLE ROLES (
    ID_ROLE SERIAL PRIMARY KEY,
    ROLE_NAME VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE USERS (
    ID_USER SERIAL PRIMARY KEY,
    USERNAME VARCHAR(50) UNIQUE NOT NULL,
    FULL_NAME VARCHAR(100) NOT NULL
);

CREATE TABLE USER_ROLES (
    ID_USER INT4 NOT NULL,
    ID_ROLE INT4 NOT NULL,
    PRIMARY KEY (ID_USER, ID_ROLE),
    FOREIGN KEY (ID_USER) REFERENCES USERS (ID_USER) ON DELETE CASCADE,
    FOREIGN KEY (ID_ROLE) REFERENCES ROLES (ID_ROLE) ON DELETE CASCADE
);


-- Insertar roles predeterminados
INSERT INTO ROLES (ROLE_NAME) VALUES ('admin');
INSERT INTO ROLES (ROLE_NAME) VALUES ('asesor');
INSERT INTO ROLES (ROLE_NAME) VALUES ('visitante');


-- Insertar usuarios
INSERT INTO USERS (USERNAME, FULL_NAME) VALUES ('cristian_acalo', 'Cristian Acalo');
INSERT INTO USERS (USERNAME, FULL_NAME) VALUES ('erick_moreira', 'Erick Moreira');
INSERT INTO USERS (USERNAME, FULL_NAME) VALUES ('diego_casignia', 'Diego Casignia');
INSERT INTO USERS (USERNAME, FULL_NAME) VALUES ('daniel_guaman', 'Daniel Guaman');

-- ASIGNACION DE ROLES

INSERT INTO USER_ROLES (ID_USER, ID_ROLE) VALUES (1, 1); -- cris admin
INSERT INTO USER_ROLES (ID_USER, ID_ROLE) VALUES (4, 2); -- daniel asesor
INSERT INTO USER_ROLES (ID_USER, ID_ROLE) VALUES (2, 3); -- erick visitante
INSERT INTO USER_ROLES (ID_USER, ID_ROLE) VALUES (3, 3); -- diego visitante

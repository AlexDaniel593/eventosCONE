CREATE TABLE AUDITORIA (
    ID SERIAL PRIMARY KEY,
    NOMBRE_TABLA VARCHAR(255) NOT NULL,
    OPERACION VARCHAR(10) NOT NULL,
    VALOR_ANTERIOR TEXT,
    NUEVO_VALOR TEXT,
    UPDATE_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    USUARIO VARCHAR(255)  -- Puedes ajustar esto según el sistema de autenticación
);


CREATE OR REPLACE FUNCTION audit_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO AUDITORIA (NOMBRE_TABLA, OPERACION, NUEVO_VALOR, UPDATE_DATE, USUARIO)
    VALUES (
        TG_TABLE_NAME,
        'INSERT',
        row_to_json(NEW)::TEXT,
        CURRENT_TIMESTAMP,
        current_user  -- Ajusta esto si usas un método diferente para capturar el usuario
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION audit_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO AUDITORIA (NOMBRE_TABLA, OPERACION, VALOR_ANTERIOR, NUEVO_VALOR, UPDATE_DATE, USUARIO)
    VALUES (
        TG_TABLE_NAME,
        'UPDATE',
        row_to_json(OLD)::TEXT,
        row_to_json(NEW)::TEXT,
        CURRENT_TIMESTAMP,
        current_user  -- Ajusta esto si usas un método diferente para capturar el usuario
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION audit_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO AUDITORIA (NOMBRE_TABLA, OPERACION, VALOR_ANTERIOR, UPDATE_DATE, USUARIO)
    VALUES (
        TG_TABLE_NAME,
        'DELETE',
        row_to_json(OLD)::TEXT,
        CURRENT_TIMESTAMP,
        current_user  -- Ajusta esto si usas un método diferente para capturar el usuario
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- auditar la tabla EVENTOS
CREATE TRIGGER trigger_insert_eventos
AFTER INSERT ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION audit_insert();

CREATE TRIGGER trigger_update_eventos
AFTER UPDATE ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION audit_update();

CREATE TRIGGER trigger_delete_eventos
AFTER DELETE ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION audit_delete();

-- auditar la tabla CLIENTES
CREATE TRIGGER trigger_insert_clientes
AFTER INSERT ON CLIENTES
FOR EACH ROW
EXECUTE FUNCTION audit_insert();

CREATE TRIGGER trigger_update_clientes
AFTER UPDATE ON CLIENTES
FOR EACH ROW
EXECUTE FUNCTION audit_update();

CREATE TRIGGER trigger_delete_clientes
AFTER DELETE ON CLIENTES
FOR EACH ROW
EXECUTE FUNCTION audit_delete();

-- auditar CATEGORIA_SERVICIO
CREATE TRIGGER trigger_insert_categoria_servicio
AFTER INSERT ON CATEGORIA_SERVICIO
FOR EACH ROW
EXECUTE FUNCTION audit_insert();

CREATE TRIGGER trigger_update_categoria_servicio
AFTER UPDATE ON CATEGORIA_SERVICIO
FOR EACH ROW
EXECUTE FUNCTION audit_update();

CREATE TRIGGER trigger_delete_categoria_servicio
AFTER DELETE ON CATEGORIA_SERVICIO
FOR EACH ROW
EXECUTE FUNCTION audit_delete();

-- auditar COTIZACIONES
CREATE TRIGGER trigger_insert_cotizaciones
AFTER INSERT ON COTIZACIONES
FOR EACH ROW
EXECUTE FUNCTION audit_insert();

CREATE TRIGGER trigger_update_cotizaciones
AFTER UPDATE ON COTIZACIONES
FOR EACH ROW
EXECUTE FUNCTION audit_update();

CREATE TRIGGER trigger_delete_cotizaciones
AFTER DELETE ON COTIZACIONES
FOR EACH ROW
EXECUTE FUNCTION audit_delete();

-- auditar PROVEEDORES
CREATE TRIGGER trigger_insert_proveedores
AFTER INSERT ON PROVEEDORES
FOR EACH ROW
EXECUTE FUNCTION audit_insert();

CREATE TRIGGER trigger_update_proveedores
AFTER UPDATE ON PROVEEDORES
FOR EACH ROW
EXECUTE FUNCTION audit_update();

CREATE TRIGGER trigger_delete_proveedores
AFTER DELETE ON PROVEEDORES
FOR EACH ROW
EXECUTE FUNCTION audit_delete();






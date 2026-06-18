    CREATE TABLE responsavel (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    senha VARCHAR(255),
    tipo ENUM('RESPONSAVEL', 'CRIANCA') NOT NULL,
    data_decriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

    CREATE TABLE vinculos (
    id SERIAL PRIMARY KEY,
    responsavel_id INT NOT NULL,
    crianca_id INT NOT NULL,
    FOREIGN KEY (responsavel_id) REFERENCES responsavel(id) ON DELETE CASCADE,
    FOREIGN KEY (crianca_id) REFERENCES crianca(id) ON DELETE CASCADE
);

    CREATE TABLE crianca (
    id SERIAL PRIMARY KEY,
    responsavel_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    login_id VARCHAR(20) UNIQUE NOT NULL,
    senha VARCHAR(255),
    FOREIGN KEY (responsavel_id)
    REFERENCES responsavel(id)
    ON DELETE CASCADE
);
	
	
SELECT * FROM crianca WHERE EXTRACT(MONTH FROM data_nascimento) = EXTRACT(MONTH FROM CURRENT_DATE);

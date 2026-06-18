    CREATE TABLE responsavel (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    senha VARCHAR(255),
    tipo ENUM('RESPONSAVEL', 'CRIANCA') NOT NULL,
    data_decriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

    CREATE TABLE vinculos (
    id INT PRIMARY KEY,
    responsavel_id INT NOT NULL,
    crianca_id INT NOT NULL,
    FOREIGN KEY (responsavel_id) REFERENCES responsavel(id) ON DELETE CASCADE,
    FOREIGN KEY (crianca_id) REFERENCES crianca(id) ON DELETE CASCADE
);

    CREATE TABLE id_login (
    id INT PRIMARY KEY,
    crianca_id INT NOT NULL,
    FOREIGN KEY (crianca_id) REFERENCES usuarios(id)
);

    CREATE TABLE crianca (
    id INT PRIMARY KEY,
    responsavel_id INT,    
    nome VARCHAR(100) NOT NULL,
    parentesco VARCHAR(50),
    FOREIGN KEY (responsavel_id) REFERENCES responsavel(idON DELETE CASCADE ); 
	
	
SELECT * FROM crianca WHERE EXTRACT(MONTH FROM data_nascimento) = EXTRACT(MONTH FROM CURRENT_DATE);

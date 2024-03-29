--CRIAÇÃO E MANUTENÇÃO DE PROCEDURES


CREATE OR REPLACE PROCEDURE AUMENTA_PRECOCURSO --PROCEDURE
(PCOD_CURSO NUMBER)                            --PARÂMETRO DA PROCEDURE

IS
--VARIAVEIS
BEGIN
  --AUMENTAR EM 10% O VALOR DO CURSO
  UPDATE TCURSO SET
  VALOR = VALOR * 1.1
  WHERE COD_CURSO = PCOD_CURSO;
END;

SELECT * FROM TCURSO;


--FORMAS DE EXECUTAR A PROCEDURE CRIADA ACIMA
BEGIN
 AUMENTA_PRECOCURSO(7);
END;


--EXECUTANDO COM BLOCO ANONIMO
DECLARE
  VCOD INTEGER := &CODIGO;
BEGIN
  AUMENTA_PRECOCURSO(VCOD);
END;


--OUTROS EXEMPLOS DE PROCEDURE
CREATE OR REPLACE PROCEDURE CONSULTA_ALUNO
(PCODIGO          IN  TALUNO.COD_ALUNO%TYPE, --PARÂMETRO DE ENTRADA (É PERMITIDO UTILIZAR COMO VALOR FIXO)
 PNOME            OUT TALUNO.NOME%TYPE,      --PARÂMETRO DE SAÍDA. OBRIGATORIAMENTE TEM QUE SER VARIAVEL POIS O VALOR DEVERÁ SER RETORNADO
 PCEP             OUT TALUNO.CEP%TYPE,
 PCIDADE          OUT TALUNO.CIDADE%TYPE)
IS
BEGIN
  SELECT NOME, CEP, CIDADE
  INTO   PNOME, PCEP, PCIDADE
  FROM   TALUNO
  WHERE  COD_ALUNO = PCODIGO; --CRITERIO DO FILTRO É TRAZER SOMENTE UM ALUNO
END;
 

--TESTE
DECLARE
  VNOME VARCHAR2(30);
  VCIDADE VARCHAR(30);
  VCEP VARCHAR(10);
  VCOD INTEGER := &CODIGO;
BEGIN
  --EXECUTANDO A PROCEDURE
  CONSULTA_ALUNO(VCOD, VNOME, VCEP, VCIDADE);
  
  DBMS_OUTPUT.PUT_LINE('CODIGO - ' || VCOD);
  DBMS_OUTPUT.PUT_LINE('NOME - '   || VNOME);
  DBMS_OUTPUT.PUT_LINE('CEP - '    || VCEP);
  DBMS_OUTPUT.PUT_LINE('CIDADE - ' || VCIDADE);
END;

SELECT * FROM TALUNO;



/*EXECUTANDO A MESMA PROCEDURE SÓ QUE DE FORMA DIFERENTE. 
É COMUM UTILIZAR ESSA FORMA DE EXECUÇÃO QUANDO SE TEM MUITOS PARÂMETROS*/
DECLARE
  VNOME VARCHAR2(30);
  VCIDADE VARCHAR(30);
  VCEP VARCHAR(10);
  VCOD INTEGER := &CODIGO;

BEGIN
  CONSULTA_ALUNO(PNOME   => VNOME,
                 PCODIGO => VCOD,
                 PCIDADE => VCIDADE,
                 PCEP    => VCEP);
    
    
  DBMS_OUTPUT.PUT_LINE('CODIGO - ' || VCOD);
  DBMS_OUTPUT.PUT_LINE('NOME - '   || VNOME);
  DBMS_OUTPUT.PUT_LINE('CEP - '    || VCEP);
  DBMS_OUTPUT.PUT_LINE('CIDADE - ' || VCIDADE);
END;



/*PEGANDO REGISTRO NUMA TABELA. FORMA RECOMENDADA 
QUANDO SE TEM MUITAS INFORMAÇÕES. UTILIZA-SE CURSOR.
DIFERENTEMENTE DO PRIMEIRO CÓDIGO, ESSE EM QUESTÃO
NÃO APRESENTA ERRO CASO NÃO ENCONTRE O CODIGO(REGISTRO)*/
CREATE OR REPLACE PROCEDURE CONSULTA_ALUNO2
(P_REGISTRO IN OUT TALUNO%ROWTYPE)           --UTILIZANDO APENAS UMA VARIÁVEL. TIPO RECORD. VARIAVEL TANTO DE ENTRADA QUANTO DE SAÍDA
IS
  CURSOR CSQL IS
    SELECT * FROM TALUNO 
    WHERE COD_ALUNO= P_REGISTRO.COD_ALUNO;
BEGIN
  OPEN CSQL;
  FETCH CSQL INTO P_REGISTRO;
  CLOSE CSQL;
END;


--TESTANDO
DECLARE
  REGISTRO TALUNO%ROWTYPE; --VARIAVEL REGISTRO DO MESMO TIPO DA TABELA TALUNO (ROWTYPE)
BEGIN
  REGISTRO.COD_ALUNO := 1;
  CONSULTA_ALUNO2(REGISTRO);
  DBMS_OUTPUT.PUT_LINE('NOME: '  ||REGISTRO.NOME);
  DBMS_OUTPUT.PUT_LINE('CIDADE: '||REGISTRO.CIDADE);
  DBMS_OUTPUT.PUT_LINE('CEP: '   ||REGISTRO.CEP);
  DBMS_OUTPUT.PUT_LINE('CÓDIGO: '||REGISTRO.COD_ALUNO);
END;


--EXEMPLO DE FORMATAÇÃO COM PROCEDURE (PORCEDURE NÃO BUSCA NADA DE BANCO, TRABALHA APENAS COM VARIAVEIS) COM 
CREATE OR REPLACE PROCEDURE FORMATA_NUMERO(PTELEFONE IN OUT VARCHAR2) --IN OUT ->TRABALHA COM VALOR E DEVOLVE NELA MESMA
IS
BEGIN
  PTELEFONE := SUBSTR(PTELEFONE, 1, 4)||'-'|| --COLOCANDO SEPARAÇÃO DE 4 EM 4 NUMEROS
               SUBSTR(PTELEFONE, 5, 4);
END;


--TESTANDO
DECLARE
  VTELEFONE VARCHAR2(20);
BEGIN
  VTELEFONE := '12345678'; --COLOCANDO VALOR NA VARIAVEL
  FORMATA_NUMERO(VTELEFONE);
  DBMS_OUTPUT.PUT_LINE(VTELEFONE); --DEVOLVENDO O RESULTADO DA VARIAVEL NA PRÓPRIA VARIAVEL
END;



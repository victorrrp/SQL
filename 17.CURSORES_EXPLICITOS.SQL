--TRABALHANDO COM CURSORES E LAÇOS
--AO LONGO DO CÓDIGO, EXEMPLOS DO MESMO SÓ QUE DE FORMA SIMPLIFCADA

DECLARE
  VCOD_ALUNO TALUNO.COD_ALUNO%TYPE;
  VNOME      TALUNO.NOME%TYPE;
  CURSOR C1 IS               --CRIANDO CURSOR
    SELECT COD_ALUNO, NOME
    FROM TALUNO;
BEGIN
  OPEN C1;                   --ABRINDO CURSOR
  LOOP
    FETCH C1 INTO VCOD_ALUNO, VNOME;       --BUSCANDO C1 EM VCOD_ALUNO
    EXIT WHEN C1%ROWCOUNT >+ 10 OR C1%NOTFOUND; --SAIR QUANDO A LINHA FOR MAIOR OU IGUAL A 10 OU QUANDO NÃO TIVER REGISTROS
    DBMS_OUTPUT.PUT_LINE('CODIGO: '||
                LPAD(VCOD_ALUNO, 5, '0')||' - '||
                'NOME: '||VNOME);
  END LOOP;                  --FECHANDO CURSOR
  CLOSE C1;
END;     


--UTILIZANDO CURSOR COM RECORD. COLOCANDO AS LINHAS DO CURSOR DENTRO DO RECORD
DECLARE
  CURSOR C1 IS
     SELECT * FROM TALUNO;
  REG C1%ROWTYPE;            --RECORD COM MESMO TIPO DO CURSOR
BEGIN
  OPEN C1;
  LOOP
      FETCH C1 INTO REG;     
      EXIT WHEN C1%ROWCOUNT > 10 OR C1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('CODIGO: '||
                  LPAD(REG.COD_ALUNO, 5, '0')||' - '||
                  'NOME: '||REG.NOME);
  END LOOP;
  CLOSE C1;
END;


--MESMO CÓDIGO, PORÉM SIMPLIFICADO (NO GERAL, É A MELHOR MANEIRA)
DECLARE
  CURSOR C1 IS
    SELECT * FROM TALUNO;
  REG TALUNO%ROWTYPE;        --RECORD COM MESMA ESTRUTURA DO CURSOR
BEGIN
  FOR REG IN C1              --ABRE E FECHA O CURSOR AUTOMATICAMENTE
  LOOP
    DBMS_OUTPUT.PUT_LINE('CODIGO: '||
                LPAD(REG.COD_ALUNO, 5, '0')||' - '||
                'NOME: '||REG.NOME);
  END LOOP;
END;    



/*MÉTODO PARECIDO PORÉM SEM CRIAR O CURSOR É COLOCANDO SELECT 
DIRETO NO FOR. RECOMENDADO PARA SELECT'S PEQUENOS*/
DECLARE
  REG TALUNO%ROWTYPE;
BEGIN
  FOR REG IN (SELECT * FROM TALUNO)
  LOOP
    DBMS_OUTPUT.PUT_LINE('CODIGO: '||
                LPAD(REG.COD_ALUNO, 5, '0')||' - '||
                'NOME: '||REG.NOME);
  END LOOP;
END; 


--CURSOR COM PARÂMETRO UTILIZANDO FOR UPDATE
DECLARE
  CURSOR C1 (PCOD_ALUNO NUMBER) IS
    SELECT * FROM TALUNO
    WHERE COD_ALUNO = PCOD_ALUNO   --PARA USAR O CURSOR É OBRIGATÓRIO PASSAR O PARAMETRO PCOD_ALUNO
  FOR UPDATE OF NOME NOWAIT;       --BLOQUEIA COLUNA NOME PARA ALTERAÇÃO
  REG C1%ROWTYPE;
BEGIN
  OPEN C1 (&CODIGO);               
  FETCH C1 INTO REG;
  DBMS_OUTPUT.PUT_LINE('CODIGO: '||
                LPAD(REG.COD_ALUNO, 5, '0')||' - '||
                'NOME: '||REG.NOME);
  CLOSE C1;                         --LIBERA O REGISTRO PARA ALTERAÇÃO
END; 



--OUTRO EXEMPLO DE FOR UPDATE
DECLARE
  CURSOR C1 IS
    SELECT NOME FROM TALUNO
    FOR UPDATE;
  REG_ALUNO C1%ROWTYPE;
BEGIN 
  FOR REG_ALUNO IN C1               --FAZENDO UM LAÇO NA TABELA
  LOOP
      UPDATE TALUNO SET
      NOME = INITCAP(REG_ALUNO.NOME)
      WHERE CURRENT OF C1;
      DBMS_OUTPUT.PUT_LINE('NOME: '||INITCAP(REG_ALUNO.NOME));
  END LOOP;
  COMMIT; 
END; 
SELECT * FROM TALUNO;



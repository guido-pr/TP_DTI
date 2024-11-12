/* Questão 1:
Encontre o nome dos alunos com nota em Banco de Dados em 2022 que foram
reprovados (Nota ou frequência menor que 60). */
SELECT ALUNOS.matricula, ALUNOS.nome, -- Seleciono as colunas desejadas da tabela.
HISTORICO.codigo AS disciplina, HISTORICO.ano, HISTORICO.nota, HISTORICO.frequencia
FROM ALUNOS -- Define a tabela principal da consulta
JOIN HISTORICO ON ALUNOS.matricula = HISTORICO.matricula -- Retorna apenas as linhas onde há correspondência em ambas as tabelas
WHERE HISTORICO.codigo = 'BD' AND HISTORICO.ano = 2022 AND (HISTORICO.nota < 60 OR HISTORICO.frequencia < 60); -- Aplica a condição de ter sido reprovado em 2022.

/* Questão 2:
Encontre os alunos que nunca cursaram uma disciplina. */
SELECT ALUNOS.matricula, ALUNOS.nome -- Seleciono as colunas desejadas da tabela.
FROM ALUNOS -- Define a tabela principal da consulta
LEFT JOIN HISTORICO ON ALUNOS.matricula = HISTORICO.matricula -- Retorna todas as linhas da tabela à esquerda e as correspondentes da tabela à direita. Retorna "NULL" se não há correspondência
WHERE HISTORICO.matricula IS NULL; -- Capta quais linhas não possuem correspondência

/* Questão 3:
Liste as médias das notas das disciplinas por ano. */
SELECT HISTORICO.codigo AS Disciplina, HISTORICO.ano AS Ano, AVG(HISTORICO.nota) AS Media_nota_anual -- Seleciono as colunas desejadas da tabela.
FROM HISTORICO -- Define a tabela principal da consulta
GROUP BY HISTORICO.codigo, HISTORICO.ano -- Agrupo as linhas pelos parametros desejados
ORDER BY HISTORICO.codigo, HISTORICO.ano; -- Ordeno as linhas pelos parametros desejados

/* Questão 5: 
Qual matéria os alunos mais reprovaram em 2022? */
SELECT DISCIPLINAS.nome AS Disciplinas, -- Seleciono as colunas desejados da tabela.
    COUNT(CASE WHEN HISTORICO.ano = 2022 AND (HISTORICO.nota < 60 OR HISTORICO.frequencia < 60) THEN 1 END) AS total_reprovados -- Conta o número de alunos reprovados em 2022 para cada disciplina
FROM HISTORICO -- Define a tabela principal da consulta
JOIN DISCIPLINAS ON HISTORICO.codigo = DISCIPLINAS.codigo  -- Retorna apenas as linhas onde há correspondência em ambas as tabelas
GROUP BY DISCIPLINAS.nome -- Agrupa os resultados por nome de disciplina
ORDER BY total_reprovados DESC -- Ordena os resultados em ordem decrescente pelo número de reprovados.
LIMIT 1; -- Exibe apenas o primeiro registro, que corresponde à disciplina com o maior número de reprovações em 2022.

/* Questão 6:
Calcule as taxas de reprovação das disciplinas por ano. */
SELECT HISTORICO.codigo AS disciplina, HISTORICO.ano, -- Seleciono as colunas desejadas da tabela.
    COUNT(CASE WHEN HISTORICO.nota < 60 OR HISTORICO.frequencia < 60 THEN 1 END) * 100.0 / COUNT(*) AS taxa_reprovacao -- Calcula a taxa de reprovação para cada combinação de disciplina e ano.
FROM HISTORICO -- Define a tabela principal da consulta
GROUP BY HISTORICO.codigo, HISTORICO.ano -- Agrupo as linhas pelos parametros desejados
ORDER BY HISTORICO.ano, HISTORICO.codigo; -- Ordeno as linhas pelos parametros desejados
    
/* Questão 8: 
Quais alunos estiveram acima da média geral de todos os alunos? */
WITH MEDIA_GERAL AS (
	SELECT AVG(Historico.nota) AS media_geral 
	FROM HISTORICO
), -- Cria uma tabela temporária com a média geral das notas
MEDIA_ALUNOS AS (
	SELECT ALUNOS.matricula, ALUNOS.nome, AVG(HISTORICO.nota) AS media_alunos
	FROM ALUNOS 
	JOIN HISTORICO
	ON ALUNOS.matricula = HISTORICO.matricula
    GROUP BY ALUNOS.matricula, ALUNOS.nome
) -- Cria uma tabela temporária com as médias de cada aluno
SELECT MEDIA_ALUNOS.matricula, MEDIA_ALUNOS.nome, MEDIA_ALUNOS.media_alunos, MEDIA_GERAL.media_geral
FROM MEDIA_ALUNOS
JOIN MEDIA_GERAL ON MEDIA_ALUNOS.media_alunos > MEDIA_GERAL.media_geral; -- Verifica quais alunos tem a média individual maior que a geral

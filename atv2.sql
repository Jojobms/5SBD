-- 1. Nomes em maiúsculas
SELECT UPPER(nome) AS nome_maiusculo
FROM cliente;

-- 2. Primeira letra maiúscula
SELECT INITCAP(nome) AS nome_formatado
FROM cliente;

-- 3. Três primeiras letras
SELECT SUBSTR(nome, 1, 3) AS iniciais
FROM cliente;

-- 4. Número de caracteres
SELECT nome, LENGTH(nome) AS qtd_caracteres
FROM cliente;

-- 5. Saldo arredondado
SELECT num_conta, ROUND(saldo) AS saldo_arredondado
FROM conta;

-- 6. Saldo truncado
SELECT num_conta, TRUNC(saldo) AS saldo_truncado
FROM conta;

-- 7. Resto da divisão por 1000
SELECT num_conta, MOD(saldo, 1000) AS resto
FROM conta;

-- 8. Data atual do servidor
SELECT SYSDATE AS data_atual
FROM dual;

-- 9. Data atual + 30 dias
SELECT SYSDATE + 30 AS data_vencimento_simulada
FROM dual;

-- 10. Dias entre abertura e hoje
SELECT num_conta,
       TRUNC(SYSDATE - data_abertura) AS dias_aberta
FROM conta;


-- 11. Saldo formatado como moeda
SELECT num_conta,
       TO_CHAR(saldo, 'L999G999D99') AS saldo_formatado
FROM conta;

-- 12. Data de abertura no formato dd/mm/yyyy
SELECT num_conta,
       TO_CHAR(data_abertura, 'DD/MM/YYYY') AS data_formatada
FROM conta;

-- 13. Substituir saldo nulo por 0
SELECT num_conta,
       NVL(saldo, 0) AS saldo_corrigido
FROM conta;

-- 14. Substituir cidade nula por 'Sem cidade'
SELECT nome,
       NVL(cidade, 'Sem cidade') AS cidade_corrigida
FROM cliente;

-- 15. Classificação de clientes por cidade
SELECT nome,
       CASE
           WHEN UPPER(cidade) = 'NITERÓI' THEN 'Região Metropolitana'
           WHEN UPPER(cidade) = 'RESENDE' THEN 'Interior'
           ELSE 'Outra Região'
       END AS classificacao
FROM cliente;

-- 16. Cliente, número da conta e saldo
SELECT c.nome, ct.num_conta, ct.saldo
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente;

-- 17. Clientes e nomes das agências
SELECT c.nome AS cliente,
       a.nome AS agencia
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
JOIN agencia a ON ct.cod_agencia = a.cod_agencia;

-- 18. Todas as agências (mesmo sem clientes) - junção externa esquerda
SELECT a.nome AS agencia,
       c.nome AS cliente
FROM agencia a
LEFT JOIN conta ct ON a.cod_agencia = ct.cod_agencia
LEFT JOIN cliente c ON ct.cod_cliente = c.cod_cliente;

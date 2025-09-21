-- 1. Nome de cada cliente e número da conta (sintaxe Oracle proprietária)
SELECT c.nome, ct.num_conta
FROM cliente c, conta ct
WHERE c.cod_cliente = ct.cod_cliente;

-- 2. Produto cartesiano (todas as combinações de clientes e agências)
SELECT c.nome AS cliente, a.nome AS agencia
FROM cliente c, agencia a;

-- 3. Cliente e cidade da agência usando aliases
SELECT c.nome, a.cidade
FROM cliente c, conta ct, agencia a
WHERE c.cod_cliente = ct.cod_cliente
  AND ct.cod_agencia = a.cod_agencia;


-- 4. Saldo total de todas as contas
SELECT SUM(saldo) AS saldo_total
FROM conta;

-- 5. Maior saldo e média de saldo
SELECT MAX(saldo) AS maior_saldo,
       AVG(saldo) AS media_saldo
FROM conta;

-- 6. Quantidade de contas cadastradas
SELECT COUNT(*) AS qtd_contas
FROM conta;

-- 7. Número de cidades distintas onde os clientes residem
SELECT COUNT(DISTINCT cidade) AS qtd_cidades
FROM cliente;

-- 8. Número da conta e saldo, substituindo nulos por 0
SELECT num_conta,
       NVL(saldo, 0) AS saldo_corrigido
FROM conta;


-- 9. Média de saldo por cidade dos clientes
SELECT c.cidade, AVG(ct.saldo) AS media_saldo
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
GROUP BY c.cidade;

-- 10. Cidades com mais de 3 contas
SELECT c.cidade, COUNT(ct.num_conta) AS qtd_contas
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
GROUP BY c.cidade
HAVING COUNT(ct.num_conta) > 3;

-- 11. Totais de saldo por cidade da agência + total geral (ROLLUP)
SELECT a.cidade, SUM(ct.saldo) AS total_saldo
FROM agencia a
LEFT JOIN conta ct ON a.cod_agencia = ct.cod_agencia
GROUP BY ROLLUP(a.cidade);

-- 12. União das cidades de clientes e agências (sem repetição)
SELECT cidade FROM cliente
UNION
SELECT cidade FROM agencia;


-- 1. Clientes com saldo acima da média geral
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo > (SELECT AVG(saldo) FROM conta);

-- 2. Clientes com saldo igual ao maior saldo
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo = (SELECT MAX(saldo) FROM conta);

-- 3. Cidades com mais clientes que a média
SELECT cidade
FROM cliente
GROUP BY cidade
HAVING COUNT(*) > (SELECT AVG(cnt) 
                   FROM (SELECT COUNT(*) AS cnt
                         FROM cliente
                         GROUP BY cidade));


-- 4. Clientes com saldo igual a qualquer um dos 10 maiores saldos
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo IN (SELECT saldo
                   FROM conta
                   ORDER BY saldo DESC
                   FETCH FIRST 10 ROWS ONLY);

-- 5. Clientes com saldo menor que todos os de Niterói
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo < ALL (SELECT ct2.saldo
                      FROM cliente c2
                      JOIN conta ct2 ON c2.cod_cliente = ct2.cod_cliente
                      WHERE UPPER(c2.cidade) = 'NITERÓI');

-- 6. Clientes com saldo entre os saldos de Volta Redonda
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo BETWEEN (SELECT MIN(ct2.saldo)
                        FROM cliente c2
                        JOIN conta ct2 ON c2.cod_cliente = ct2.cod_cliente
                        WHERE UPPER(c2.cidade) = 'VOLTA REDONDA')
                  AND (SELECT MAX(ct2.saldo)
                       FROM cliente c2
                       JOIN conta ct2 ON c2.cod_cliente = ct2.cod_cliente
                       WHERE UPPER(c2.cidade) = 'VOLTA REDONDA');


-- 7. Clientes com saldo maior que a média da agência
SELECT c.nome
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo > (SELECT AVG(ct2.saldo)
                  FROM conta ct2
                  WHERE ct2.cod_agencia = ct.cod_agencia);

-- 8. Clientes com saldo inferior à média da sua cidade
SELECT c.nome, c.cidade
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
WHERE ct.saldo < (SELECT AVG(ct2.saldo)
                  FROM cliente c2
                  JOIN conta ct2 ON c2.cod_cliente = ct2.cod_cliente
                  WHERE c2.cidade = c.cidade);


-- 9. Clientes com pelo menos uma conta
SELECT c.nome
FROM cliente c
WHERE EXISTS (SELECT 1
              FROM conta ct
              WHERE ct.cod_cliente = c.cod_cliente);

-- 10. Clientes sem conta registrada
SELECT c.nome
FROM cliente c
WHERE NOT EXISTS (SELECT 1
                  FROM conta ct
                  WHERE ct.cod_cliente = c.cod_cliente);


-- 11. Clientes com saldo acima da média da sua cidade
WITH media_por_cidade AS (
    SELECT c.cidade, AVG(ct.saldo) AS media_saldo
    FROM cliente c
    JOIN conta ct ON c.cod_cliente = ct.cod_cliente
    GROUP BY c.cidade
)
SELECT c.nome, c.cidade, ct.saldo
FROM cliente c
JOIN conta ct ON c.cod_cliente = ct.cod_cliente
JOIN media_por_cidade m ON c.cidade = m.cidade
WHERE ct.saldo > m.media_saldo;



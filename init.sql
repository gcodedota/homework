-- ids:
-- id: bigserial
-- idx: bytea # 16 bytes, indexed, used for lookup
-- remainder: bytea # remainder of binary data
-- type: smallint # 0=eoa 1=contract 2=txhash 3=blockhash

CREATE TABLE IF NOT EXISTS ids (
  id bigserial PRIMARY KEY,
  idx bytea NOT NULL,
  remainder bytea NOT NULL,
  type smallint NOT NULL
);

COMMENT ON COLUMN ids.type IS '0=eoa 1=contract 2=txhash 3=blockhash';

CREATE INDEX ids_idx_index ON ids (idx);

-- nicks:
-- id: bigint # foreign key id@ids
-- nick: string # nickname of the particular id
-- type: smallint # indicates nickname type

CREATE TABLE IF NOT EXISTS nicks (
  id bigint NOT NULL,
  nick varchar(30) NOT NULL,
  type smallint NOT NULL,
  FOREIGN KEY (id) REFERENCES ids(id)
);

-- erc20tokens:
-- id: bigint # foreign key id@ids
-- name: string # token name
-- symbol: string # token symbol
-- decimals: smallint # how many decimals the token has
-- supply: bigint # divided by decimals

CREATE TABLE IF NOT EXISTS erc20tokens (  
  id bigint NOT NULL,
  name varchar(200) NOT NULL,
  symbol varchar(7) NOT NULL,
  decimals smallint NOT NULL,
  supply bigint NOT NULL,
  FOREIGN KEY (id) REFERENCES ids(id)
);

-- blocks:
-- id: bigint # foreign key id@ids, the blockhash
-- height: int # block height in the chain
-- created_at: int # unix ts

CREATE TABLE IF NOT EXISTS blocks (  
  height int UNIQUE,
  id bigint NOT NULL,
  created_at int NOT NULL,
  FOREIGN KEY (id) REFERENCES ids(id)
);

-- txs:
-- txhash: bigint # foreign key id@ids, the txhash
-- block: int # block height, foreign key height@blocks
-- value: bigint # in gwei
-- from_id: bigint # foreign key id@ids
-- to_id: bigint # foreign key id@ids
-- gas_limit: bigint
-- gas_price: bigint
-- method_id: int? # 4 bytes
-- params: bytea? # not contract deployment, not erc20 tx

CREATE TABLE IF NOT EXISTS txs (  
  txhash bigint NOT NULL,
  block int NOT NULL,
  value bigint NOT NULL,
  from_id bigint NOT NULL,
  to_id bigint NOT NULL,
  gas_limit bigint NOT NULL,
  gas_price bigint NOT NULL,
  method_id int,
  params bytea,
  FOREIGN KEY (txhash) REFERENCES ids(id),
  FOREIGN KEY (block) REFERENCES blocks(height),
  FOREIGN KEY (from_id) REFERENCES ids(id),
  FOREIGN KEY (to_id) REFERENCES ids(id)
);

-- ethtxs: # if data == 0x tx gets inserted
-- txhash: bigint # foreign key id@ids
-- from_id: bigint # foreign key id@ids
-- to_id: bigint # foreign key id@ids
-- value: bigint # in gwei

CREATE TABLE IF NOT EXISTS ethtxs (  
  txhash bigint NOT NULL,
  from_id bigint NOT NULL,
  to_id bigint NOT NULL,
  value bigint NOT NULL,
  FOREIGN KEY (txhash) REFERENCES ids(id),
  FOREIGN KEY (from_id) REFERENCES ids(id),
  FOREIGN KEY (to_id) REFERENCES ids(id)
);

-- erc20txs: # if first four bytes indicate transfer signature tx gets inserted
-- txhash: bigint # foreign key id@ids
-- token_id: bigint # foreign key id@ids
-- from_id: bigint # foreign key id@ids
-- to_id: bigint # foreign key id@ids
-- value: bigint # divided by decimals

CREATE TABLE IF NOT EXISTS erc20txs (  
  txhash bigint NOT NULL,
  token_id bigint NOT NULL,
  from_id bigint NOT NULL,
  to_id bigint NOT NULL,
  value bigint NOT NULL,
  FOREIGN KEY (txhash) REFERENCES ids(id),
  FOREIGN KEY (token_id) REFERENCES ids(id),
  FOREIGN KEY (from_id) REFERENCES ids(id),
  FOREIGN KEY (to_id) REFERENCES ids(id)
);

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

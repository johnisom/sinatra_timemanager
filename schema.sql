CREATE TABLE users (
    PRIMARY KEY (id),
    id            serial,
    username      varchar(16) UNIQUE NOT NULL,
                  CONSTRAINT username_length_check
                  CHECK (LENGTH(username) BETWEEN 2 AND 16),
                  CONSTRAINT username_only_alphanumeric
                  CHECK (username ~ '^\w+$'),
    password_hash varchar(60)        NOT NULL,
                  CONSTRAINT password_hash_length_check
                  CHECK (LENGTH(password_hash) BETWEEN 59 AND 60),
                  CONSTRAINT password_hash_follows_bcrypt
                  CHECK (password_hash ~
                            ('^\$2(?:a|b)' ||                   -- Version
                             '\$(?:[4-9]|[1-2][0-9]|3[0-1])' || -- Cost
                             '\$[\w./]{22}' ||                  -- Salt
                             '[\w./]{31}$'))                     -- Hash
);

CREATE TABLE sessions (
    PRIMARY KEY (id),
    id serial,
    start_time    timestamp DEFAULT NOW() NOT NULL,
    start_message text      DEFAULT NULL,
    stop_time     timestamp DEFAULT NOW(),
    stop_message  text      DEFAULT NULL,
    user_id       integer                 NOT NULL,
                  FOREIGN KEY (user_id)
                  REFERENCES users (id)
                  ON DELETE CASCADE
);

CREATE TABLE credentials (
    PRIMARY KEY (username),
    username      varchar(16),
		  CONSTRAINT username_length_check
		  CHECK (LENGTH(username) BETWEEN 2 AND 16),
                  CONSTRAINT username_only_alphanumeric
                  CHECK (username ~ '^\w+$'),
    password_hash varchar(60) NOT NULL,
    		  CONSTRAINT password_hash_length_check
		  CHECK (LENGTH(password_hash) BETWEEN 59 AND 60),
                  CONSTRAINT password_hash_follows_bcrypt
                  CHECK (password_hash ~
                            ('^\$2(?:a|b)' ||                   -- Version
                             '\$(?:[4-9]|[1-2][0-9]|3[0-1])' || -- Cost
                             '\$[\w./]{22}' ||                  -- Salt
                             '[\w./]{31}$'))                     -- Hash
);

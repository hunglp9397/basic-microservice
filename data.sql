
CREATE TABLE currency_exchange (
    id int,
    currency_from varchar(255),
    currency_to varchar(255),
    conversion_multiple int,
    environment varchar(255)
);

insert into currency_exchange
(id,currency_from,currency_to,conversion_multiple,environment)
values(10001,'USD','INR',65,'');

insert into currency_exchange
(id,currency_from,currency_to,conversion_multiple,environment)
values(10002,'EUR','INR',75,'');

insert into currency_exchange
(id,currency_from,currency_to,conversion_multiple,environment)
values(10003,'AUD','INR',25,'');


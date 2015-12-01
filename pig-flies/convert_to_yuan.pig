/*
converts the stock prices from USD to YUAN.
*/
register udfs.jar;
define USDtoYUAN udfs.USDtoYUAN();

stock = load 'NYSE_dividends' as (exchange:chararray, symbol:chararray, date:chararray, price:float);
stock_clean = foreach stock generate symbol;
names = foreach stock_clean generate USDtoYUAN($0);
dump names;
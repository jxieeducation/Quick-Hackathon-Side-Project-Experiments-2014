/*
see which stock symbols appear the most in the dataset
*/
raw = load 'NYSE_dividends' as (exchange:chararray, symbol:chararray, data:chararray, rate:float);
-- describe raw;
stocks = group raw by symbol;
-- describe stocks;
counts = foreach stocks generate group, COUNT(raw);
-- describe counts;
ordered_list = order counts by $1;
processed_list = group ordered_list by $0;
final_list = foreach processed_list generate group, $1;
dump final_list;
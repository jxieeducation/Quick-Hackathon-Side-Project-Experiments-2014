/*calculating each stock's avg dividend*/
dividends = load 'NYSE_dividends' as (exchange:chararray, symbol:chararray, date:chararray, dividend:float);
grouped_stocks = group dividends by symbol;
average_per_stock = foreach grouped_stocks generate group, AVG(dividends.dividend);
dump average_per_stock;

/*calculating all stocks' avg dividend*/
grouped = group dividends all;
average_all_stock = foreach grouped generate group, AVG(dividends.dividend);
dump average_all_stock;

/*calculating the average dividend of stocks with symbols of less than 3 characters*/
two_char_stocks = filter dividends by SIZE(symbol) < 3;
grouped_two_chars = group two_char_stocks all;
two_chars = foreach grouped_two_chars generate group, AVG(two_char_stocks.dividend);
dump two_chars;


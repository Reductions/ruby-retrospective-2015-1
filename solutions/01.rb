def convert_to_bgn(amount, currency)
  ratio = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}
  (amount * ratio[currency]).round(2)
end

def compare_prices(first_amount, first_currency, second_amount, second_currency)
  convert_to_bgn(first_amount, first_currency) <=>
    convert_to_bgn(second_amount, second_currency)
end

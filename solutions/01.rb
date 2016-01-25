def convert_to_bgn(amount,currency)
  case currency
  when :bgn
    amount.round(2)
  when :usd
    (amount * 1.7408).round(2)
  when :eur
    (amount * 1.9557).round(2)
  when :gbp
    (amount * 2.6415).round(2)
  end
end

def compare_prices(first_amount,first_currency,second_amount,second_currency)
  convert_to_bgn(first_amount,first_currency) <=>
    convert_to_bgn(second_amount,second_currency)
end

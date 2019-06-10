# QiwiObserver

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/qiwi_observer`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qiwi_observer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qiwi_observer

## Usage
#### Инициализируйте объект
 - request = QiwiObserver::Payments.new(wallet: '7XXXXXXXXXX', token: 'asd23dsvdljoihiscgasdcrpoi')

#### Вызовите метод #call  на объекте с переданным хэшом, формата {rows: Integer, operation: String, startDate: DateTime, endDate: DateTime}*
 - response = request.call({rows: 15, operation: 'IN'})

#### Сделайте проверку, при успешном запросе через метод #short_info получите массив хэшей с информацией платежей 
 - if response.success?
     - result = response.short_info
 - else
     - redirect_to some_apth flash {error: response.error}
 - end
    - ##### rows: целое число от 1 до 50. Обязательный параметр.
    - ##### Возможные значения параметра operation: ALL, IN, OUT & QIWI_CARD.
    - ##### startDate: Начальная дата поиска платежей. Дату можно указать в любой временной зоне TZD (формат ГГГГ-ММ-ДД'T'чч:мм:ссTZD), однако она должна совпадать с временной зоной в параметре endDate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QiwiObserver project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qiwi_observer/blob/master/CODE_OF_CONDUCT.md).

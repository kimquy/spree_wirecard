# Spree Wirecard

Add support for Wirecard's QPAY payment page as a payment method.

## Installation

1. Add the following to your Gemfile

<pre>
    gem 'spree_wirecard', :git => 'git://github.com/clemens/spree_wirecard.git'
</pre>

2. Run `bundle install`

3. To copy and apply migrations run: `rails g spree_wirecard:install`

## Configuring

1. Add a new Payment Method, using `BillingIntegration::Wirecard::QPAYCheckout` as the `Prodivder`.

2. Click `Create`, and enter your Store's Wirecard QPAY Customer ID and secret in the fields provided.

3. Configure the rest to suit your needs.

4. `Save` and start using it!

Copyright (c) 2012 [name of extension creator], released under the MIT License

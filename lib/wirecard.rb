module Wirecard
  autoload :Request, 'wirecard/request'
  autoload :Response, 'wirecard/response'

  class << self
    def payment_page_url
      'https://secure.wirecard-cee.com/qpay/init.php'
    end

    def md5(string)
      Digest::MD5.hexdigest(string)
    end
  end
end

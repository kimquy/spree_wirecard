# encoding: utf-8

require 'spec_helper'

describe Wirecard::Request do
  let(:expected_fingerprint) { '1337h4xx0r' }
  let(:test_params) do
    { 
      :amount           => 99.99,
      :orderDescription => 'Order 1',
      :successURL       => 'http://test.host/success_url',
    }
  end
  let(:request) { Wirecard::Request.new(test_params) }

  before(:each) do
    Wirecard.config.stub(:secret).and_return('secret')
    Wirecard.config.stub(:customer_id).and_return('1337')
    Wirecard.stub(:payment_page_url => 'https://example.com')
    Wirecard.stub(:md5).with('secret133799.99EURenOrder 1http://test.host/success_urlsecret,customerId,amount,currency,language,orderDescription,successURL,requestFingerprintOrder').and_return(expected_fingerprint)
  end

  describe "#generate_fingerprint" do
    it "generates an md5 fingerprint for the given parameters" do
      request.generate_fingerprint.should == expected_fingerprint
      request.params[:requestFingerprint].should == expected_fingerprint
    end
  end
end

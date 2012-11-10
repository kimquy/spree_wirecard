# encoding: utf-8

require 'spec_helper'

describe Wirecard::Response do
  let(:common_params) do
    {
      "amount"=>"95.0",
      "currency"=>"EUR",
      "paymentType"=>"CCARD",
      "financialInstitution"=>"MC",
      "language"=>"en",
      "orderNumber"=>"12219028",
      "paymentState"=>"SUCCESS",
      "utf8"=>"✓",
      "authenticated"=>"No",
      "anonymousPan"=>"0002",
      "expiry"=>"12/2012",
      "gatewayReferenceNumber"=>"DGW_12219028_RN",
      "avsResponseCode"=>"X",
      "avsResponseMessage"=>"Demo AVS ResultMessage",
      "responseFingerprintOrder"=>"amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,utf8,authenticated,anonymousPan,expiry,gatewayReferenceNumber,avsResponseCode,avsResponseMessage,secret,responseFingerprintOrder",
      "responseFingerprint"=>"7e4ee0896959d69e8970b8759a3b9948",
    }
  end
  let(:params) { common_params }
  let(:response) { Wirecard::Response.new(params) }

  describe "#amount" do
    it "turns the amount into a number" do
      response.amount.should == 95.0
    end
  end

  describe "#success?" do
    context "with payment state SUCCESS" do
      let(:params) { common_params.merge("paymentState" => 'SUCCESS') }

      it "returns true" do
        response.should be_success
      end
    end

    %w[FAILURE CANCEL].each do |payment_state|
      context "with payment state #{payment_state}" do
        let(:params) { common_params.merge("paymentState" => payment_state) }

        it "returns false" do
          response.should_not be_success
        end
      end
    end
  end

  describe "#failure?" do
    context "with payment state FAILURE" do
      let(:params) { common_params.merge("paymentState" => 'FAILURE') }

      it "returns true" do
        response.should be_failure
      end
    end

    %w[SUCCESS CANCEL].each do |payment_state|
      context "with payment state #{payment_state}" do
        let(:params) { common_params.merge("paymentState" => payment_state) }

        it "returns false" do
          response.should_not be_failure
        end
      end
    end
  end

  describe "#cancelled?" do
    context "with payment state CANCEL" do
      let(:params) { common_params.merge("paymentState" => 'CANCEL') }

      it "returns true" do
        response.should be_cancelled
      end
    end

    %w[SUCCESS FAILURE].each do |payment_state|
      context "with payment state #{payment_state}" do
        let(:params) { common_params.merge("paymentState" => payment_state) }

        it "returns false" do
          response.should_not be_cancelled
        end
      end
    end
  end

  describe "#has_valid_fingerprint?" do
    context "with valid fingerprint" do
      let(:params) { common_params.merge("responseFingerprint" => '7e4ee0896959d69e8970b8759a3b9948') }

      it "returns true" do
        response.should have_valid_fingerprint
      end
    end

    context "with invalid fingerprint" do
      let(:params) { common_params.merge("responseFingerprint" => 'WRONG')}

      it "returns false" do
        response.should_not have_valid_fingerprint
      end
    end
  end
end

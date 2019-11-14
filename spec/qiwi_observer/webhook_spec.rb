require 'spec_helper'
require './lib/qiwi_observer/webhook/webhook'

RSpec.describe QiwiObserver::Webhook do
  it "is don't create without secret key" do
    expect{described_class.new}.to raise_error ArgumentError
  end

  describe '#call' do
    let(:webhook) {described_class.new('JcyVhjHCvHQwufz+IHXolyqHgEc5MoayBfParl6Guoc=')}
    describe "when arguments don't set" do
      it 'raise error ArgumentError' do
        expect{webhook.call}.to raise_error ArgumentError
      end
    end

    describe 'when webhook response' do
      it 'is success return true' do
        params = {
          messageId: "7814c49d-2d29-4b14-b2dc-36b377c76156",
          hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22",
          payment: {
            txnId: "13353941550",
            date: "2018-06-27T13:39:00+03:00",
            type: "IN",
            status: "SUCCESS",
            errorCode:"0",
            personId: 78000008000,
            account: "+79165238345",
            comment:"",
            provider:7,
            sum: {
              amount:1,
              currency: 643
            },
            commission: {
              amount: 0,
              currency: 643
            },
            total: {
              amount: 1,
              currency: 643
            },
            signFields: "sum.currency,sum.amount,type,account,txnId"
          },
          hash: "76687ffe5c516c793faa46fafba0994e7ca7a6d735966e0e0c0b65eaa43bdca0",
          version: "1.0.0",
          test: false
        }
        expect(webhook.call(params).success?).to eq true
      end

      it 'is not success return false' do
        params = {
          messageId: "7814c49d-2d29-4b14-b2dc-36b377c76156",
          hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22",
          payment: {
            txnId: "13353941550",
            date: "2018-06-27T13:39:00+03:00",
            type: "IN",
            status: "SUCCESS",
            errorCode:"0",
            personId: 78000008000,
            account: "+79165238345",
            comment:"",
            provider:7,
            sum: {
              amount:1,
              currency: 643
            },
            commission: {
              amount: 0,
              currency: 643
            },
            total: {
              amount: 1,
              currency: 643
            },
            signFields: "sum.currency,sum.amount,type,account,txnId"
          },
          hash: "76687ffe5c516c793faa46fafba0994e7ca7a6d735966e0e0c0b65eaa43bdca1",
          version: "1.0.0",
          test: false
        }
        expect(webhook.call(params).success?).to eq false
      end
    end

    describe "when webhook's sign hash is correct" do
      it 'returns transaction value' do
        params = {
          messageId: "7814c49d-2d29-4b14-b2dc-36b377c76156",
          hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22",
          payment: {
            txnId: "13353941550",
            date: "2018-06-27T13:39:00+03:00",
            type: "IN",
            status: "SUCCESS",
            errorCode:"0",
            personId: 78000008000,
            account: "+79165238345",
            comment:"",
            provider:7,
            sum: {
              amount:1,
              currency: 643
            },
            commission: {
              amount: 0,
              currency: 643
            },
            total: {
              amount: 1,
              currency: 643
            },
            signFields: "sum.currency,sum.amount,type,account,txnId"
          },
          hash: "76687ffe5c516c793faa46fafba0994e7ca7a6d735966e0e0c0b65eaa43bdca0",
          version: "1.0.0",
          test: false
        }
        expect(webhook.call(params).value).to include(
          :txnId, :date, :type, :status,
          :errorCode, :sum, :commission,
          :total, :personId, :comment,
          :account, :provider
        )
      end
    end

    describe "when webhook's sign hash is not correct" do
      it 'returns transaction error' do
        params = {
          messageId: "7814c49d-2d29-4b14-b2dc-36b377c76156",
          hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22",
          payment: {
            txnId: "13353941550",
            date: "2018-06-27T13:39:00+03:00",
            type: "IN",
            status: "SUCCESS",
            errorCode:"0",
            personId: 78000008000,
            account: "+79165238345",
            comment:"",
            provider:7,
            sum: {
              amount:1,
              currency: 643
            },
            commission: {
              amount: 0,
              currency: 643
            },
            total: {
              amount: 1,
              currency: 643
            },
            signFields: "sum.currency,sum.amount,type,account,txnId"
          },
          hash: "76687ffe5c516c793faa46fafba0994e7ca7a6d735966e0e0c0b65eaa43bdca1",
          version: "1.0.0",
          test: false
        }
        expect(webhook.call(params).error).to eq("This #13353941550 transaction is not authenticated")
      end
    end

    describe "when API send test POST request" do
      it 'returns empty webhook' do
        params = {
          messageId: nil,
          hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22",
          payment: nil,
          hash: nil,
          version: "1.0.0",
          test: true
        }
        expect(webhook.call(params).value).to include(messageId: nil, hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22", payment: nil, hash: nil, version: "1.0.0", test: true)
      end
    end
  end
end

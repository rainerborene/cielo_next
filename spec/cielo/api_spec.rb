require "spec_helper"

describe Cielo do
  it "should set default credentials" do
    Cielo.merchant_id.wont_be_nil
    Cielo.merchant_key.wont_be_nil
    Cielo.environment.must_equal :sandbox
  end

  it "should query payment info details" do
    response = VCR.use_cassette "details" do
      cielo = Cielo::API.new
      cielo.find_by_payment("5248d46d-f306-47d7-89ab-9c59c0c6061d")
    end

    response.merchant_order_id.must_equal "90561903-e096-4868-b9f6-7b13ae676149"
    response.customer.wont_be_nil
    response.payment.wont_be_nil
  end

  it "should query all payments done by given merchant" do
    response = VCR.use_cassette "query" do
      cielo = Cielo::API.new
      cielo.find_payments_by_order("90561903-e096-4868-b9f6-7b13ae676149")
    end

    response.reason_message.wont_be_nil "Successful"
    response.payments.size.must_equal 1
  end

  it "should create a new recurrent payment" do
    response = VCR.use_cassette "charge" do
      cielo = Cielo::API.new
      cielo.create_sale(charge_params)
    end

    response.payment.recurrent_payment.recurrent_payment_id.wont_be_nil
    response.payment.recurrent_payment.next_recurrency.must_equal "2019-07-11"
  end

  it "should cancel existing payment" do
    response = VCR.use_cassette "cancel" do
      cielo = Cielo::API.new
      cielo.cancel_sale("a083e638-d6f1-47c5-a4dd-11dc2991b018")
    end

    response.status.must_equal 10
    response.reason_message.must_equal "Successful"
  end

  it "should deactive recurrent payment" do
    canceled = VCR.use_cassette "deactive" do
      cielo = Cielo::API.new
      cielo.deactivate_recurrent_payment("75492527-c594-4787-bcb7-834110d0ee19")
    end

    canceled.must_equal true
  end

  it "should update existing recurrent payment" do
    VCR.use_cassette "update" do
      cielo = Cielo::API.new
      cielo.update_recurrent_payment("818934d7-e690-40d3-ba83-84990474b643",
        type: "CreditCard",
        amount: 100_00,
        installments: 1,
        credit_card: {
          card_number: "1273981798794101",
          holder: "Ana",
          expiration_date: "12/2020",
          security_code: 102,
          brand: "Master"
        }
      )
    end
  end

  it "should capture sale" do
    response = VCR.use_cassette "capture" do
      cielo = Cielo::API.new
      cielo.capture_sale("5248d46d-f306-47d7-89ab-9c59c0c6061d")
    end

    response.status.must_equal 2
  end

  def charge_params
    {
      merchant_order_id: SecureRandom.uuid,
      customer: { name: "Maria" },
      payment: {
        type: "CreditCard",
        amount: 1500,
        installments: 1,
        soft_descriptor: "App",
        recurrent_payment: {
          authorize_now: true,
          interval: "Annual"
        },
        credit_card: {
          card_number: "1234123412341231",
          holder: "Maria",
          expiration_date: "12/2030",
          security_code: 262,
          brand: "Visa"
        }
      }
    }
  end
end

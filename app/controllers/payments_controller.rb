class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  before_action :set_cart


  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  def set_cart
    session[:cart] ||= []
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  def add_to_cart
    @product = Product.find(params[:id])
    session[:cart] << @product
    redirect_to products_path
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

def execute
  @paypal_payment = PayPal::SDK::REST::Payment.find(params[:paymentId])
  if @paypal_payment.execute(payer_id: params[:PayerID])
    @amount = @paypal_payment.transactions.collect(&:amount).collect(&:total).map(&:to_f).sum()

    @payment = PayPal::SDK::REST::Payment.create(
      code: @paypal_payment.id,
      payment_method: "paypal",
      amount: @amount,
      currency: "USD")

      render plain: ":)"
    else
      render json: @paypal_payment.to_json
    end
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:code, :payment_method, :amount, :currency)
    end
end

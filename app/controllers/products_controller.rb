class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  require 'paypal-sdk-rest'
  include PayPal::SDK::REST
  include PayPal::SDK::Core::Logging
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def buy
    @payment = Payment.new({
    :intent =>  "sale",

    # ###Payer
    # A resource representing a Payer that funds a payment
    # Payment Method as 'paypal'
    :payer =>  {
      :payment_method =>  "paypal" },

    # ###Redirect URLs
    :redirect_urls => {
      :return_url => "http://localhost:3000/payments/execute",
      :cancel_url => "http://localhost:3000/" },

    # ###Transaction
    # A transaction defines the contract of a
    # payment - what is the payment for and who
    # is fulfilling it.
    :transactions =>  [{

      # Item List
      :item_list => {
        :items => [{
          :name => "item",
          :sku => "item",
          :price => "5",
          :currency => "USD",
          :quantity => 1 }]},

      # ###Amount
      # Let's you specify a payment amount.
      :amount =>  {
        :total =>  "5",
        :currency =>  "USD" },
      :description =>  "This is the payment transaction description." }]})

    if @payment.create
        @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
        redirect_to @redirect_url
    else
      render json: @payment.error
    end

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :price)
    end
end

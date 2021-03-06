class StocksController < ApplicationController

	def new
		@user = current_user
		@stock = @user.stocks.build
	end

	def create
		unless params[:stock_lookup].nil? || params[:stock_lookup] == ""
			stock_symbol, stock_name, stock_exchange = params[:stock_lookup].split(',')
			@user = current_user
			@stock = Stock.find_by_yahoo_symbol(stock_symbol)
			if @stock.nil?
				@stock = Stock.new
				@stock.yahoo_symbol = stock_symbol
				@stock.exchange = stock_exchange
				@stock.company_name = stock_name
				@stock.save
				Tweet.download_tweets(Tweet.get_authorized, @stock.yahoo_symbol)
			end
			if @user.stocks.find_by_yahoo_symbol(stock_symbol).nil?
				@user.stocks << @stock
				@user.save

			end
		end
		redirect_to user_path(current_user), :notice => "#{@stock.company_name} is added to portfolio." 
	end

	def destroy
		current_user.stocks.destroy(params[:id])
		respond_to do |format|
			format.html { redirect_to user_url(current_user), alert: "Your portfolio is updated." }
			format.json { head :no_content }
		end
	end

	private
	def stock_params
		params.require(:stock).permit(:yahoo_symbol, :twitter_symbol, :company_name, :search, :id)
	end

end

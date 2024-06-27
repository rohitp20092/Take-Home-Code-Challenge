module Api
  module V1
    class TransactionsController < ApplicationController
      def create
        transaction_data = transaction_params
        transaction = Transaction.new(transaction_data)
        
        if transaction.save
          render json: { status: 'success', transaction_id: transaction.transaction_id }, status: :ok
        else
          render json: { status: 'error', errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:transaction_id, :points, :user_id, :status)
      end
    end
  end
end
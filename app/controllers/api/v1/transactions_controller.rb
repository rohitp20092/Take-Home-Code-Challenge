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

      def bulk_transactions
        transactions_data = bulk_transaction_params[:transactions]
        transactions = transactions_data.map { |data| Transaction.new(data) }

        if transactions.map(&:valid?).all?
          Transaction.import(transactions, validate: true)
          render json: { status: 'success', processed_count: transactions.size }, status: :ok
        else
          errors = transactions.map{|tran| { transaction_data: tran, errors: tran.errors.full_messages }}
          render json: { status: 'error', errors: errors}, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:transaction_id, :points, :user_id, :status)
      end

      def bulk_transaction_params
        params.permit(transactions: [:transaction_id, :points, :user_id, :status])
      end
    end
  end
end

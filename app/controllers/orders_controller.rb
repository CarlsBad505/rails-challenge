class OrdersController < ApplicationController

  def create_order
    return missing_param("customer_id missing") unless params[:customer_id]
    return invalid_param("customer_id invalid") unless Customer.find_by_id(params[:customer_id])
    return missing_param("variants missing") unless params[:variants]
    invalid_ids = []
    invalid_quantities = []
    params[:variants].each do |variant|
      return missing_param("variant id missing") unless variant[:id]
      invalid_ids << variant[:id] unless v = Variant.find_by_id(variant[:id])
      return missing_param("quantity missing") unless variant[:quantity]
      invalid_quantities << {id: variant[:id], quantity_available: v.stock_amount} unless !v || variant[:quantity] <= v.stock_amount
    end
    return invalid_param("variant id invalid", invalid_ids) unless invalid_ids.empty?
    return invalid_quantity("quantity unfulfillable", invalid_quantities) unless invalid_quantities.empty?

    data = JSON.parse(request.body.read, symbolize_names: true)
    order = Order.new
    order.build_order(data)
    return action_failed unless order.save
    order.variants_orders.includes(:variant).each { |variant_order| variant_order.variant.update_stock_amount(variant_order.quantity) }
    render json: {status: 201, order_id: order.id}, status: 201
  rescue => errors
    return action_failed
  end

  def read_order
    return invalid_param("order_id invalid") unless order = Order.find_by_id(params[:order_id])
    data = order.read_view
    render json: data, status: 200
  rescue => errors
    return action_failed
  end
end

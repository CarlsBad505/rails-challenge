require 'rails_helper'

Rails.describe "POST New Order", type: :request do
  it "returns 400 if customer_id missing" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      variants: [
        {
          id: 1,
          quantity: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("customer_id missing")
    expect(response).to have_http_status(400)
  end

  it "returns 400 if variants missing" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("variants missing")
    expect(response).to have_http_status(400)
  end

  it "returns 400 if variant id missing" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1,
      variants: [
        {
          quantity: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("variant id missing")
    expect(response).to have_http_status(400)
  end

  it "returns 400 if quantity missing" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1,
      variants: [
        {
          id: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("quantity missing")
    expect(response).to have_http_status(400)
  end

  it "returns 404 if customer_id invalid" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 300,
      variants: [
        {
          id: 1,
          quantity: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("customer_id invalid")
    expect(response).to have_http_status(404)
  end

  it "returns 404 if variant id invalid" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1,
      variants: [
        {
          id: 10000,
          quantity: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("variant id invalid")
    expect(response_body).to include(:variants)
    expect(response_body[:variants]).to all(be_a(Integer))
    expect(response).to have_http_status(404)
  end

  it "returns 422 if quantity unfulfillable" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1,
      variants: [
        {
          id: 1,
          quantity: 10000
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("quantity unfulfillable")
    expect(response_body).to include(:variants)
    expect(response_body[:variants]).to all(include(:id, :quantity_available))
    expect(response).to have_http_status(422)
  end

  it "returns 201 if order created successfully" do
    headers = {
      "Content-Type" => "application/json",
      "ACCEPT" => "application/json"
    }
    body = {
      customer_id: 1,
      variants: [
        {
          id: 1,
          quantity: 1
        }
      ]
    }
    post "/v1/api/orders/create", params: body.to_json, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:order_id]).to be_a(Integer)
    expect(response).to have_http_status(201)
  end
end

Rails.describe "GET Order By ID", type: :request do
  it "returns 404 if order_id invalid" do
    headers = {
      "Content-Type" => "application/json"
    }
    get "/v1/api/orders/2000", params: nil, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body[:error]).to eq("order_id invalid")
    expect(response).to have_http_status(404)
  end

  it "returns 200 if order_id valid" do
    headers = {
      "Content-Type" => "application/json"
    }
    get "/v1/api/orders/1", params: nil, headers: headers
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.content_type).to eq("application/json")
    expect(response_body).to include(:order_id)
    expect(response_body).to include(:customer_id)
    expect(response_body).to include(:total_price)
    expect(response_body).to include(:status)
    expect(response_body).to include(:created_at)
    expect(response_body).to include(:updated_at)
    expect(response_body).to include(:variants)
    expect(response_body[:variants]).to all(include(:id, :name, :price, :quantity))
    expect(response).to have_http_status(200)
  end
end

require 'rails_helper'

RSpec.describe "POST Order", type: :routing do
  it "routes /v1/api/orders/create" do
    expect(post("/v1/api/orders/create")).to route_to(controller: "orders", action: "create_order", format: "json")
  end
end

RSpec.describe "GET Order", type: :routing do
  it "routes /v1/api/orders/:order_id" do
    expect(get("/v1/api/orders/1")).to route_to(controller: "orders", action: "read_order", format: "json", order_id: "1")
  end
end

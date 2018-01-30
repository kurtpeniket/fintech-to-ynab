class YNABClient

  BASE_URL = 'https://api.youneedabudget.com/papi/v1'

  def initialize(access_token)
    @access_token = access_token
  end

  def budgets
    get('/budgets')[:budgets]
  end

  def accounts(budget_id)
    get("/budgets/#{budget_id}/accounts")[:accounts]
  end

  def categories(budget_id)
    get("/budgets/#{budget_id}/categories")
  end

  def payees(budget_id)
    get("/budgets/#{budget_id}/payees")[:payees]
  end

  def transactions(budget_id)
    get("/budgets/#{budget_id}/transactions")[:transactions]
  end

  def create_transaction(budget_id: nil, account_id: nil, payee_id: nil, category_id: nil, amount: nil, cleared: nil, date: nil, memo: nil)
    parse_response(RestClient.post(BASE_URL + "/budgets/#{budget_id}/transactions", {
      transaction: {
        account_id: account_id,
        date: date.to_s,
        amount: amount,
        category_id: category_id,
        payee_id: payee_id,
        cleared: cleared ? "Cleared" : 'Uncleared',
        memo: memo
      }
    }, {
      'Authorization' => "Bearer #{@access_token}"
    }))
  end

  def get(url)
    parse_response(RestClient.get(BASE_URL + url, { 'Authorization' => "Bearer #{@access_token}" }))
  end

  protected

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true)[:data]
  end

end
import EmbarkJS from 'Embark/EmbarkJS'
import $ from 'jquery'
import Token from 'Embark/contracts/Token'

window.Token = Token
window.EmbarkJS = EmbarkJS

let currentToken

$(document).ready(function() {
  EmbarkJS.onReady(error => {
    if (error) {
      console.error('Error while connecting to web3', error)
      return
    }

    $('#deployToken button').click(function() {
      var supply = $('#deployToken input').val()
      Token.deploy({ arguments: [supply], data: Token.options.data })
        .send({ gas: 400000 })
        .then(function(deployedToken) {
          currentToken = deployedToken
          $('#deployToken .result').append(
            '<br>Token deployed with address: ' + deployedToken.options.address
          )
        })
    })

    $('#useToken button').click(function() {
      var address = $('#useToken input').val()
      console.dir(Token.abi)
      currentToken = new EmbarkJS.Contract({
        abi: Token.options.jsonInterface,
        address: address
      })
    })

    web3.eth.getAccounts(function(err, accounts) {
      $('#queryBalance input').val(accounts[0])
    })

    $('#queryBalance button').click(function() {
      var address = $('#queryBalance input').val()
      currentToken.methods
        .balanceOf(address)
        .call()
        .then(function(balance) {
          $('#queryBalance .result').html(balance)
        })
    })

    $('#transfer button').click(function() {
      var address = $('#transfer .address').val()
      var num = $('#transfer .num').val()

      currentToken.methods
        .transfer(address, num)
        .send()
        .then(function() {
          $('#transfer .result').html('Done!')
        })
    })
  })
})

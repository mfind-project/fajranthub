const express = require('express');
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(bodyParser.json());

app.post('/', function(req, res) {
  console.log('someone pinged @', req);
  if (req.body.type === 'ADDED_TO_SPACE') {
    return res.json({
      "text": "Dzięki za dodanie do pokoju."
    });
  } else if (req.body.type === 'MESSAGE') {
    if (req.body.message.argumentText) {
      console.log('req.body.message', req.body.message);
      var amount = req.body.message.argumentText.match(/\d+/g);
      if (!amount) {
        return res.json({
          "text": "Nie rozpoznaje polecenia"
        });
      } else {
        amount = amount[0];
      }

      if (req.body.message.argumentText.indexOf('h') !== -1) {
        amount += 'godzin';
      } else if (req.body.message.argumentText.indexOf('min') !== -1) {
        amount += 'minut';
      } else {
        amount += 'minut';
      }

      return res.json({
        "cards": [
          {
            "sections": [
              {
                "widgets": [
                  {
                    "textParagraph": {
                      "text": `<b>${req.body.user.displayName}</b> zapisano <font color=\"#ff0000\">${amount}</font> przerwy`
                    }
                  }
                ]
              }
            ]
          }
        ]
      });
    } else 
    return res.json(
      {
        "cards": [
          {
            "sections": [
              {
                "widgets": [
                  {
                    "textParagraph": {
                      "text": "Co chcesz zrobić?"
                    }
                  },
                  {
                    "buttons": [
                      {
                        "textButton": {
                          "text": "Przedłuż",
                          "onClick": {
                            "action": {
                              "actionMethodName": "inc",
                              "parameters": [
                                {
                                  "key": "amount",
                                  "value": "10min"
                                }
                              ]
                            }
                          }
                        }
                      },
                      {
                        "textButton": {
                          "text": "Zakończ",
                          "onClick": {
                            "action": {
                              "actionMethodName": "finish"
                            }
                          }
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    );


    return res.json(
      {
        "cards": [
          {
            "sections": [
              {
                "widgets": [
                  {
                    "textParagraph": {
                      "text": "Za ile wracasz?"
                    }
                  },
                  {
                    "buttons": [
                      {
                        "textButton": {
                          "text": "10min",
                          "onClick": {
                            "action": {
                              "actionMethodName": "brb",
                              "parameters": [
                                {
                                  "key": "amount",
                                  "value": "10min"
                                }
                              ]
                            }
                          }
                        }
                      },
                      {
                        "textButton": {
                          "text": "20min",
                          "onClick": {
                            "action": {
                              "actionMethodName": "brb",
                              "parameters": [
                                {
                                  "key": "amount",
                                  "value": "20min"
                                }
                              ]
                            }
                          }
                        }
                      },
                      {
                        "textButton": {
                          "text": "30min",
                          "onClick": {
                            "action": {
                              "actionMethodName": "brb",
                              "parameters": [
                                {
                                  "key": "amount",
                                  "value": "30min"
                                }
                              ]
                            }
                          }
                        }
                      }
                      
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    );
  } else if (req.body.type == 'CARD_CLICKED') {

    if (req.body.action.actionMethodName === 'finish') {
      return res.json({
        "cards": [
          {
            "sections": [
              {
                "widgets": [
                  {
                    "textParagraph": {
                      "text": `<b>${req.body.user.displayName}</b> zakończona przerwa`
                    }
                  }
                ]
              }
            ]
          }
        ]
      });
    } else if (req.body.action.actionMethodName === 'inc') {
      return res.json(
        {
          "cards": [
            {
              "sections": [
                {
                  "widgets": [
                    {
                      "textParagraph": {
                        "text": "Za ile wracasz?"
                      }
                    },
                    {
                      "buttons": [
                        {
                          "textButton": {
                            "text": "10min",
                            "onClick": {
                              "action": {
                                "actionMethodName": "brb",
                                "parameters": [
                                  {
                                    "key": "amount",
                                    "value": "10min"
                                  }
                                ]
                              }
                            }
                          }
                        },
                        {
                          "textButton": {
                            "text": "20min",
                            "onClick": {
                              "action": {
                                "actionMethodName": "brb",
                                "parameters": [
                                  {
                                    "key": "amount",
                                    "value": "20min"
                                  }
                                ]
                              }
                            }
                          }
                        },
                        {
                          "textButton": {
                            "text": "30min",
                            "onClick": {
                              "action": {
                                "actionMethodName": "brb",
                                "parameters": [
                                  {
                                    "key": "amount",
                                    "value": "30min"
                                  }
                                ]
                              }
                            }
                          }
                        }
                        
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      );
    }
    var amount  = req.body.action.parameters[0].value;
    return res.json({
      "cards": [
        {
          "sections": [
            {
              "widgets": [
                {
                  "textParagraph": {
                    "text": `<b>${req.body.user.displayName}</b> zapisano <font color=\"#ff0000\">${amount}</font> przerwy`
                  }
                }
              ]
            }
          ]
        }
      ]
    });
  } else {
    return res.json({
      "text": req.body.type
    });
  }
});

app.listen(8100, function() {
  console.log('App listening on port 8100.');

  // setTimeout(function() {
  //   unirest.post('https://chat.googleapis.com/v1/spaces/' + {ROOM-ID} + '/messages')
  //   .headers({
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer " + token
  //   })
  // }, 4000);
});

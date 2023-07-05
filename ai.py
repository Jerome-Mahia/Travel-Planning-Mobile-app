import openai
import os
openai.api_key = os.environ.get('open_ai_key')
import json
def get_completion(prompt, model="gpt-3.5-turbo"):
    messages = [{"role": "user", "content": prompt}]
    response = openai.ChatCompletion.create(
        model=model,
        messages=messages,
        temperature=0, # this is the degree of randomness of the model's output
    )
    #print(response['usage']['total_tokens'])
    #print(response)
    print(response['usage'])
    test = json.loads(response.choices[0].message["content"])
    #print(test['day3'])
    print(test['day1'][0]['activity'])
    print(test['day1'][0]['budget'])
    return response.choices[0].message["content"]

prompt = """you are a travel planner Create a high end  3 day itinerary for a trip to Toronto  including the budget for each activity in dollars and if applicable the location of each activity in latitude and longitude format .
            Format the itinerary as a json object with the days as the keys for example day1.
            Each key should have a value that is a list of 3 objects.
            Each object having activity,budget and location as keys.
            The first object should describe in detail the activites  to be done in the morning the 2nd in the afternoon and 3rd in the evening.
            Do not include morning,evening or afternoon in the activity description.
        """
response = get_completion(prompt)
print(response)
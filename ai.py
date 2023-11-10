import openai
import os
openai.api_key = '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'
import json
def get_completion(prompt, model="gpt-3.5-turbo"):
    messages = [{"role": "user", "content": prompt}]
    response = openai.ChatCompletion.create(
        model=model,
        messages=messages,
        temperature=1, # this is the degree of randomness of the model's output
    )
  
    return response.choices[0].message["content"]

prompt = """Is the Universal Declaration of Human Rights truly universal, or are there inherent cultural
biases in its principles? Discuss the challenges and opportunities of applying a global
standard of human rights across diverse cultural contexts and propose potential strategies
to address these challenges

        """
response = get_completion(prompt)
print(response)
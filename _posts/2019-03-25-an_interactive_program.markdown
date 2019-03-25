---
title: An Interactive Programming Language
date: 2019-03-25 12:23:20 +04:30
categories: programming
---

Back when I started to program, all my programs where something like this:

{% highlight python %}
inp = get_input()
out = process(inp)
print_result(out)
{% endhighlight %}

It didn't took me long for that to become:

{% highlight python %}
while not quit:
    choose = prompt_choose()

    if(choose == 1):
        do_first()
    elif(choose == 2):
        do_second()

{% endhighlight %}

Those were the days. Developing interactive programs wasn't that hard. Nowadays, developing interactive program for me is something along these lines:

{% highlight python %}
def bot(msg, state):
    if state == "state_1":
        action, state = do_first(msg, state)
    elif state == "state_2":
        action, state = do_second(msg, state)
    ...
    return action, state
{% endhighlight %}

Remeber that I omitted all the code related to saving and loading state, which could actually be tricky. I'm aware that there are other options out there, for example using [`needjs`](https://www.npmjs.com/package/needjs), the code will turn to this:

{% highlight javascript %}
{% raw %}
sys.register(new Need.Ask({
  name: "first_name",
  text: "What's your name?"
}));

sys.register(new Need({
  name: "say hi",
  req: ["first_name"],
  post: function(inputs){
     bot.sendMessage(inputs.sid, "Hi " + inputs.first_name);
  }
}));

sys.trigger(MY_USER, 'say hi');
{% endraw %}
{% endhighlight %}

Which is easier, but also a lot wordier, and now I have to worry about needs and their dependency systems.

What I'm trying to say is, these days trying to write stateful programs that interact with users(more than one) specially when there are more than one users, is really hard.

So I was thinking, how can I change this?

I want to write programs that look like this:

{% highlight javascript %}
{% raw %}

stateful function chat(){
    state send("Hi, welcome to my stateful app!");
    let name = state input("What is your name?");
    state send("Hello " + name);
}

{% endraw %}
{% endhighlight %}

And basically this should be converted into something like this:

{% highlight javascript %}
{% raw %}
function chat(){
    await this.state('unique_id_1', ()=>{
        return send.apply(this.state, ["Hi, welcome to my stateful app!"]);
    });
    let name = await this.state('unique_id_2', ()=>{
        return input.apply(this.state, ["What is your name?"]);
    });
    await this.state('unique_id_3', ()=>{
        return send.apply(this.state, ["Hello " + name]);
    });
}
{% endraw %}
{% endhighlight %}

And of course the State would be a special async function that doesn't run the same code for the same session more than once.

You might ask, doesn't this look more complicated? How should I write that?

Well, I'm hoping to use `babel` or something similiar in order to transform the code without the programmer having to write the complicated stuff.

## Challenges

However, there are a few challenges that I have to face.

### Loops

Making the code work inside loops is a challenge that I'm still thinking about. There are different ways to implement a loop proof system, however, I'm not sure which would be better.

### Server Restart

The stateful function should 'resume' upon server restart.

### Code change

If the programmer changes the code and then restart the server... well, there are tons of different things that could be done in these scenarios. Perhaps one could implement a pluggable system, however in order to keep things simple it should put convention over configuration, meaning the programmer should not have to config everything, but if she wants to change how something works, she should be able to.

### Other challenges?

There might be many, many different types of challenges that I'm not thinking about at the moment. If you can think of one, and have solution for it, please don't forget to drop a comment [here](https://github.com/MCSH/MCSH.github.io/issues/20)! You'll need a Github account.

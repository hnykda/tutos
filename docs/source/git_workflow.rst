Integration with GitHub
=======================

For starter it's necessary to say, that GitHub...

...is awesome! If you don't needed and you went through whole process above, you can probably save a lot of headaches just by using GitHub. You don't need any special knowledge for start, but you will need to learn them on the fly while reading this tutorial (there is really a lot about git out there, google is your friend).

The variant I propose here is very easy, scalable and fast. Probably the most easy and effective I've found.

Why to use it
--------------

I was so happy when I deployd my first django project. But few weeks later I've found that it's just not feeling right to make changes on live version of the website (sometimes refered as *production*). So I started to use GitHub and found a solution. 

Here I will cover this:
For every your website you end up with one directory including three subdirectories.

1. First called **production** - it's the one which is live on the internet - the one what ``nginx`` refers.
2. Second called **mydomain.git** - this one is necessary for our github configuration. You will barely change there anything
3. Last one - **work_dir** - the one where all changes are being made and is connected to GitHub 


Workflow
------------

Your work will look like this:

1. Your work_dir contains master branch. This branch can be pushed to production (to go live) anywhen! So when you want to make change to your website, you need create new branch (correctly named based on the change you are doing - e.g. *hotfix_plugin*, *typo_css*...) and when you finish and test this branch, you merge it to master.
2. You push master to your GitHub repository
3. You push master to your production folder on your computer

Set it all up
-------------

So how to do it? I suppose you have one working directory as we created in previous chapters.

Now go to the place where you websites are stored. Mine is in ``/var/www`` and create this structure::

    mydomain
    ├── mydomain.git
    ├── production
    └── work_dir

Go to ``/var/www/mydomain.git`` and type this::

    git init --bare

this will create just git repository with some special folders. You don't need to know anything about it. All you need to do is to create this file ``/var/www/mydomain/mydomain.git/hooks/post-receive`` and add this::

    #!/bin/sh
    git --work-tree=/var/www/mydomain/production --git-dir=/var/www/mydomain/mydomain.git checkout -f

and make the script runable ``chmod +x /var/www/mydomain/mydomain.git/hooks/post-receive``

Go to work_dir and paste there you current *production* code (the one from previous chapters). Now you need to make a GitHub repository from that. The best guide is this one: `How to add existing folder to GitHub <https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/>`_. (Maybe you'll need to `generate SSH key <https://help.github.com/articles/generating-ssh-keys/>`_). Is it working? Great. 

    Note: It's very good to make git repositories as small as possible, so don't add to repository files which are not necessary or you backup them somewhere else. But virtualenv is a good thing to add there to IMHO.

Now just add another remote, which will point to our created git repository. Every time we'll want to go live with master, we'll push changes to this git repository and it will take care to transfer our files to production. So in work_dir type::

    git remote add production file::///var/www/mydomain/mydomain.git

and that's all. When you now want to push changes to production, type ``git push production master``. Congratulations!

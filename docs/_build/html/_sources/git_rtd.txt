Simple GitHub repo and ReadTheDocs set up
=========================================

I've just wanted to set up a GitHub repository for this guide and I found that it's really ubearable to set so simple thing as this.

Here is short guide which should walk you through:

1. Creating repository on GitHub
2. Cloning it into your local machine
3. Submitting changes from your local machine using SSH
4. Submitting changes from repository on GitHub
5. Generating documentation with `ReadTheDocs <https://readthedocs.org/>`_ and `sphinx <http://sphinx-doc.org/>_`.

Creating repository on GitHub
-----------------------------

If you've found this guide, I guess you are inteligent enough to create account on GitHub, so we'll skip this step. Same with installing git and SSH on your machine. Use google if you are lost.

To create a directory just go to your profile (e.g. https://github.com/your_username), click on **repositories** and then click on **NEW**. It's important to make repository **public** (default choice). You can also create README and LICENCE file - do it, if you want. 

When repository is created, copy **Subversion checkout URL** which can be found in right panel of repository view. In my case it's::

    https://github.com/kotrfa/test_repo

Cloning repository
------------------

Open terminal and choose folder where you'd like to clone your repository. In my case it is just my home directory. Go to this folder and run::

    git clone https://github.com/kotrfa/test_repo

``cd`` inside this folder. You should see LICENCE and README (in case you've created them) but it might be empty if you haven't insert anything through browser to your repository yet.

Setting up git 
--------------
Now we need to initialize git folder. To do this run::

    git init

this will create ``.git`` folder with all important informations. You don't need to mess with that for now.

Next thing we have to do is to setup username. To do this run::

    git config --global user.email "your_email@your_mail.something"
    git config --global user.name "your_username"

Let's test it now by creating file::
    
    touch test_file.txt

now we have to add this file to git's eye - that it has to look if this file changed and in case it does, it will upgrade it on the remote repository on GitHub. Do that by::
    
    git add test_file.txt

and now tell git that this file is prepared to be upgraded::

    git commit test.md -m "testing file"

``-m`` switch is for message and string ``"testing file"`` is the message which just gives some info about this ``commit``. 

Now we will send this changes to remote repository on GitHub. It's pretty easy::

    git push

and type your username and password as it asks for it.

If this work, we can set connection without necessity typing our credentials every time.

Setting up SSH
--------------

For some reasons it's not really straigth forward to set up this. 

First you have to go on GitHub website and go to **Account settings**. Navigate to **SSH Keys** and click on **SSH Key**. 

Title is whatever you want to call it. Key field is what is interesting.

Go again to console and type::

    ssh-keygen -t rsa -C "your_email_on_GitHub@mail.something"

and choose password as you want (or none). 

It will generate SSH key inside ``~/.ssh`` and it has two parts - public (with ``.pub`` ending) and private. Content of the public must be copied into **Key** field on the GitHub page.

Now, when you'd like to work in github repository you've to run::
    
    eval `ssh-agent -s`;ssh-add ~/.ssh/github_private_key

this should do the trick. Now you can ``git push`` as you wish without necessity to insert credentials.

Submitting changes from repository
----------------------------------
To do that just use::

    git pull

Generating docs with sphinx and RtD
-----------------------------------

Local sphinx generator
~~~~~~~~~~~~~~~~~~~~~~~
Install ``sphinx`` using ``pip`` and navigate yourself into git directory. Create ``docs`` folder there and go inside. Run::
    
    sphinx-quickstart

and set to your needs.

Add your source rst files into some directory inside ``docs``, for example ``source``. Now edit ``index.rst`` and add there ``source/filenames.rst``. In my case::

    .. toctree::
       :maxdepth: 3
        
       source/intro
       source/nec_know
       source/domains_ip_servers
       source/ndg
       source/Arch
       source/RPi

where ``maxdepth`` says how much level should TOC has. Another useful directives are ``:glob:``. In previous example I should just use ``source/*`` and it would load all ``.rst`` files inside ``source`` dir. If you'd like to have TOC numbered, just add ``:numbered:``.

Now just run::

    make html

and it will make a HTML pages for you inside ``build/html`` directory. 

Go to the main git folder (in my case ``~/test_repo``) and add, commit and push all changes::
    
    git add --all
    git commit -a -m "first docs"
    git push

Read the Docs configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Go to the `ReadTheDocs <https://readthedocs.org/>`_ and create an account there. 

Click on the dasboard and then on **import**. Name your project and add your git url inside **Repo**. In my case it's::

    https://github.com/kotrfa/test_repo

Repository type is **Git** and documentation **Sphinx Html**. Rest is basicaly optional. Now just click on **Create** and wait. 

Now you just have to wait :) . RtD will build your project every time it detects changes. Usually it was imediately, but sometimes it takes even several minutes.

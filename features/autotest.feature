Feature: autotest
    The autotest command is a Perl TDD tool to automatically run Perl
    tests whenever a change is made to either the main Perl code or the
    test code

    Background:
        Given some perl code to test

    Scenario: Running autotest runs the tests
        When the autotest command is run
        Then the perl code tests have been run

    Scenario: Auto-detected changes to perl code
        Given autotest is already running
        When a change to the perl code tests is made
        Then autotest re-runs the perl code tests

    Scenario: Auto-detect changes to test code
        Given autotest is already running
        When a change to the main perl code is made
        Then autotest re-runs the perl code tests

    Scenario: Syntax check made on perl code changes
        Given autotest is already running
        When a syntaxically bad change to the main perl code is made
        Then autotest detects the bad syntax
        And autotest does not re-run the perl tests

    Scenario: Syntax check made on test code changes
        Given autotest is already running
        When a syntaxically bad change to the perl tests is made
        Then autotest detects the bad syntax
        And autotest does not re-run the perl tests

    Scenario: Only matching test is run for a single code change
        Given autotest is already running
        When a single perl code file has been changed
        Then only it's corresponding test file is run

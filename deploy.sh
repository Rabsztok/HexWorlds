#!/bin/bash
MIX_ENV=prod mix edeliver build release && mix edeliver deploy release to production && mix edeliver restart production

/**
	Provides a web based administration interface.

	Copyright: © 2012-2013 RejectedSoftware e.K.
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
	Authors: Sönke Ludwig
*/
module vibedist.admin;

import vibedist.controller;
import vibedist.engine;

import std.exception;
import std.file;
import std.process : spawnProcess;
import vibe.core.log;
import vibe.http.server;
import vibe.inet.path;

void showAdminHome(HTTPServerRequest req, HTTPServerResponse res)
{
	Config config;
	getConfig(config);

	res.renderCompat!("home.dt",
		HTTPServerRequest, "req",
		Config*, "config",
		PublicInterface[], "interfaces")
		(req, &config, g_interfaces);
}

void startNode(HTTPServerRequest req, HTTPServerResponse res)
{
	auto path = Path(req.form["path"]);
	enforce(path.absolute, "The path to the vibe application must be absolute.");

	string[] args;
	args ~= "dub";
	args ~= "--";
	args ~= "--disthost";
	args ~= "127.0.0.1";
	auto cwd = getcwd();
	chdir(path.toNativeString());
	scope(exit) chdir(cwd);
	auto process = spawnProcess(args);
	logInfo("Spawned %s as %d", path.toString(), process);

	res.redirect("/");
}

void reloadNode(HTTPServerRequest req, HTTPServerResponse res)
{

}
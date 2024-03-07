<?php

use Illuminate\Support\Facades\Route;


/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

//Route::get( "/users", \App\Http\Controllers\User\IndexController::class);
//Route::get(  \App\Http\Controllers\User\IndexController::class,"/users");


Route::get(uri: "/users", action: \App\Http\Controllers\User\IndexController::class);
//Route::get( action: \App\Http\Controllers\User\IndexController::class, uri: "/users");

<?php
declare(strict_types=1);

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\IndexRequest;
use App\UseCase\User\IndexAction;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class IndexController extends Controller
{
    /**
     * Handle the incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function __invoke(IndexRequest $request, IndexAction $action):JsonResponse
    {
        $body = $action($request);

        return response()->json($body);
    }
}

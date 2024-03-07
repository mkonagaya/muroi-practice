<?php
declare(strict_types=1);

namespace App\UseCase\User;

use App\Http\Requests\User\IndexRequest;
use App\Models\User;

class IndexAction
{

    public function __invoke(IndexRequest $request):array
    {
        $users= User::query()->where(column: "is_active", operator: "=", value: true);

//        return compact(var_name: "users");
        return ["users" => $users,];
    }

}

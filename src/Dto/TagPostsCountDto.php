<?php

namespace App\Dto;

use Symfony\Component\Uid\Uuid;

readonly class TagPostsCountDto
{
    public function __construct(
        private Uuid $id,
        private string $name,
        private int $postsCount,
    ) {
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getPostsCount(): int
    {
        return $this->postsCount;
    }
}
